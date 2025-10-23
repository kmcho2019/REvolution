module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        // Default assignments
        shut_off_computer = 0;
        keep_driving = 0;
        
        // Conditional overrides
        if (cpu_overheated)
            shut_off_computer = 1;
        if (~arrived)
            keep_driving = ~gas_tank_empty;
    end

endmodule