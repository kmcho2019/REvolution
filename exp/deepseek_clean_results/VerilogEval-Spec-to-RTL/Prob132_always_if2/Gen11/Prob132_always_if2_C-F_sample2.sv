module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Safety shutdown: Activate when CPU overheats
    assign shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;
    
    // Driving control logic:
    // Continue driving only if we haven't arrived AND there's gas
    assign keep_driving = (~arrived) & (~gas_tank_empty);

endmodule