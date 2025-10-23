module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Computer shuts off immediately and exclusively when CPU overheats
    assign shut_off_computer = cpu_overheated;

    // Driving continues only when not arrived AND tank has gas
    // Explicitly covers all cases without needing default assignments
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule