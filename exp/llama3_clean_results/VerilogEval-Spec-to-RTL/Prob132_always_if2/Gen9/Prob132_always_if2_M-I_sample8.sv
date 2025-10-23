module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Directly assign shut_off_computer based on cpu_overheated
    assign shut_off_computer = cpu_overheated;

    // Use a more explicit approach to handle the keep_driving logic
    assign keep_driving = (!arrived && !gas_tank_empty);

    // Optional: add a comment or a separate signal to indicate when driving can continue after arrival
    // assign can_continue_driving = !gas_tank_empty;

endmodule