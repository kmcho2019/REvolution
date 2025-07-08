module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Default value prevents latch inference
        shut_off_computer = 0;
        if (cpu_overheated)
            shut_off_computer = 1;
    end

    always @(*) begin
        // Default value prevents latch inference
        keep_driving = 0;
        if (~arrived)
            keep_driving = ~gas_tank_empty;
    end

endmodule