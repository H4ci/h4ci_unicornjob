INSERT INTO `addon_account` (`id`, `name`, `label`, `shared`) VALUES
(9, 'society_unicorn', 'Unicorn', 1);

INSERT INTO `addon_inventory` (`id`, `name`, `label`, `shared`) VALUES
(16, 'society_unicorn', 'Unicorn', 1);

INSERT INTO `jobs` (`name`, `label`, `whitelisted`, `SecondaryJob`) VALUES
('unicorn', 'Unicorn', 1, 0);

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(30, 'unicorn', 0, 'novice', 'Novice', 100, '', ''),
(31, 'unicorn', 1, 'experimente', 'Experimenté', 100, '', ''),
(32, 'unicorn', 2, 'boss', 'Patron', 100, '', '');