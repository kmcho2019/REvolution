module TopModule (
    input  cpu_overheated,
    output shut_off_computer,
    input  arrived,
    input  gas_tank_empty,
    output keep_driving
);

    // Combined logic in a single always block
    reg shut_off, keep_drive;
    
    always @(*) begin
        shut_off = cpu_overheated;
        keep_drive = (~arrived) & (~gas_tank_empty);
    end

    // Continuous assignments to outputs
    assign shut_off_computer = shut_off;
    assign keep_driving = keep_drive;

endmodule