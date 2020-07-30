-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema process
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema process
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `process` ;
USE `process` ;

-- -----------------------------------------------------
-- Table `process`.`status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`status` (
  `status_id` INT NOT NULL AUTO_INCREMENT,
  `status_name` VARCHAR(45) NULL,
  PRIMARY KEY (`status_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`platforms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`platforms` (
  `platform_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `endpoint` VARCHAR(45) NOT NULL,
  `rate` DOUBLE NOT NULL,
  `date_created` DATETIME NOT NULL,
  `date_modified` DATETIME NULL,
  `type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`platform_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(45) NOT NULL,
  `lastname` VARCHAR(45) NOT NULL,
  `contact` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `date_created` DATETIME NOT NULL,
  `date_modified` DATETIME NULL,
  `balance` DOUBLE NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`payments` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `status_id` INT NOT NULL,
  `platform_id` INT NOT NULL,
  `ender_number` VARCHAR(45) NOT NULL,
  `amount` DOUBLE NOT NULL,
  `rate` DOUBLE NOT NULL,
  `date_initiated` DATETIME NOT NULL,
  `date_completed` DATETIME NULL,
  PRIMARY KEY (`payment_id`),
  INDEX `fk_payment_status_idx` (`status_id` ASC) VISIBLE,
  INDEX `fk_payment_users1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_payment_platform1_idx` (`platform_id` ASC) VISIBLE,
  CONSTRAINT `fk_payment_status1`
    FOREIGN KEY (`status_id`)
    REFERENCES `process`.`status` (`status_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_payment_platform2`
    FOREIGN KEY (`platform_id`)
    REFERENCES `process`.`platforms` (`platform_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_payment_users2`
    FOREIGN KEY (`user_id`)
    REFERENCES `process`.`users` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`external_tran_ref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`external_tran_ref` (
  `external_ref` VARCHAR(45) NOT NULL,
  `checked` TINYINT NOT NULL DEFAULT 0,
  `response` VARCHAR(45) NULL,
  `reqeust_id` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`external_ref`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`transactions` (
  `transaction_id` INT NOT NULL,
  `status_id` INT NOT NULL,
  `platform_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `amount` DOUBLE NOT NULL,
  `rate` DOUBLE NULL,
  `transaction_detail` JSON NULL,
  `date_initiated` DATETIME NOT NULL,
  `date_completed` DATETIME NULL,
  `external_ref` VARCHAR(45) NULL,
  PRIMARY KEY (`transaction_id`),
  INDEX `fk_transaction_status1_idx` (`status_id` ASC) VISIBLE,
  INDEX `fk_transaction_users1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_transaction_platform1_idx` (`platform_id` ASC) VISIBLE,
  INDEX `fk_transactions_external_mobile_ref1_idx` (`external_ref` ASC) VISIBLE,
  CONSTRAINT `fk_transaction_status2`
    FOREIGN KEY (`status_id`)
    REFERENCES `process`.`status` (`status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_platform2`
    FOREIGN KEY (`platform_id`)
    REFERENCES `process`.`platforms` (`platform_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_users2`
    FOREIGN KEY (`user_id`)
    REFERENCES `process`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transactions_external_mobile_ref2`
    FOREIGN KEY (`external_ref`)
    REFERENCES `process`.`external_tran_ref` (`external_ref`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`sms_senders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`sms_senders` (
  `sender_id` INT NOT NULL AUTO_INCREMENT,
  `status_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `sender` VARCHAR(45) NOT NULL,
  `body` VARCHAR(100) BINARY NOT NULL,
  `recipient_number` INT NULL,
  `date_initiated` DATETIME NULL,
  `date_completed` DATETIME NULL,
  PRIMARY KEY (`sender_id`),
  INDEX `fk_sms_sender_status1_idx` (`status_id` ASC) VISIBLE,
  INDEX `fk_sms_sender_users1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_sms_sender_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `process`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sms_sender_status1`
    FOREIGN KEY (`status_id`)
    REFERENCES `process`.`status` (`status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`external_sms_ref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`external_sms_ref` (
  `external_sms_id` VARCHAR(45) NOT NULL,
  `checked` TINYINT NOT NULL DEFAULT 0,
  `response` VARCHAR(45) NULL,
  `external_ref` VARCHAR(45) NULL,
  PRIMARY KEY (`external_sms_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`sms_logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`sms_logs` (
  `sms_id` INT NOT NULL AUTO_INCREMENT,
  `status_id` INT NOT NULL,
  `sender_id` INT NOT NULL,
  `platform_id` INT NOT NULL,
  `receiver` VARCHAR(45) NOT NULL,
  `rate` DOUBLE NULL,
  `date_sent` DATETIME NULL,
  `external_sms_id` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`sms_id`),
  INDEX `fk_sms_logs_sms_sender1_idx` (`sender_id` ASC) VISIBLE,
  INDEX `fk_sms_logs_status1_idx` (`status_id` ASC) VISIBLE,
  INDEX `fk_sms_logs_platform1_idx` (`platform_id` ASC) VISIBLE,
  INDEX `fk_sms_logs_external_sms_ref1_idx` (`external_sms_id` ASC) VISIBLE,
  CONSTRAINT `fk_sms_logs_sms_sender1`
    FOREIGN KEY (`sender_id`)
    REFERENCES `process`.`sms_senders` (`sender_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sms_logs_platform1`
    FOREIGN KEY (`platform_id`)
    REFERENCES `process`.`platforms` (`platform_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sms_logs_status1`
    FOREIGN KEY (`status_id`)
    REFERENCES `process`.`status` (`status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sms_logs_external_sms_ref1`
    FOREIGN KEY (`external_sms_id`)
    REFERENCES `process`.`external_sms_ref` (`external_sms_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`deductions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`deductions` (
  `deduct_id` INT NOT NULL AUTO_INCREMENT,
  `sms_id` INT NULL,
  `mm_id` INT NULL,
  `transaction_id` INT NULL,
  `amount` DOUBLE NOT NULL,
  `date_deducted` DATETIME NOT NULL,
  PRIMARY KEY (`deduct_id`),
  INDEX `fk_deductions_transaction1_idx` (`transaction_id` ASC) VISIBLE,
  INDEX `fk_deductions_sms_logs1_idx` (`sms_id` ASC) VISIBLE,
  CONSTRAINT `fk_deductions_transaction1`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `process`.`transactions` (`transaction_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_deductions_sms_logs1`
    FOREIGN KEY (`sms_id`)
    REFERENCES `process`.`sms_logs` (`sms_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`collections`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`collections` (
  `collection_id` INT NOT NULL AUTO_INCREMENT,
  `payment_id` INT NOT NULL,
  `amount` DOUBLE NOT NULL,
  PRIMARY KEY (`collection_id`),
  INDEX `fk_collections_payments1_idx` (`payment_id` ASC) VISIBLE,
  CONSTRAINT `fk_collections_payments1`
    FOREIGN KEY (`payment_id`)
    REFERENCES `process`.`payments` (`payment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`external_mm_ref`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`external_mm_ref` (
  `external_ref` VARCHAR(45) NOT NULL,
  `request_id` VARCHAR(45) NOT NULL,
  `checked` TINYINT NOT NULL DEFAULT 0,
  `response` VARCHAR(45) NULL,
  `details` VARCHAR(45) NULL,
  PRIMARY KEY (`external_ref`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `process`.`moblie_money_transfers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `process`.`moblie_money_transfers` (
  `mm_id` INT NOT NULL AUTO_INCREMENT,
  `status_id` INT NOT NULL,
  `platform_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `ender_number` VARCHAR(45) NOT NULL,
  `amount` VARCHAR(45) NOT NULL,
  `rate` DOUBLE NOT NULL,
  `date_iniated` DATETIME NOT NULL,
  `date_completed` DATETIME NOT NULL,
  `external_ref` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`mm_id`, `external_ref`),
  INDEX `fk_moblie_money_transfers_platforms1_idx` (`platform_id` ASC) VISIBLE,
  INDEX `fk_moblie_money_transfers_users1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_moblie_money_transfers_status1_idx` (`status_id` ASC) VISIBLE,
  INDEX `fk_moblie_money_transfers_external_mm_ref1_idx` (`external_ref` ASC) VISIBLE,
  CONSTRAINT `fk_moblie_money_transfers_platforms1`
    FOREIGN KEY (`platform_id`)
    REFERENCES `process`.`platforms` (`platform_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_moblie_money_transfers_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `process`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_moblie_money_transfers_status1`
    FOREIGN KEY (`status_id`)
    REFERENCES `process`.`status` (`status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_moblie_money_transfers_external_mm_ref1`
    FOREIGN KEY (`external_ref`)
    REFERENCES `process`.`external_mm_ref` (`external_ref`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
