module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Single always block for both outputs
    always @(*) begin
        // Default values (computer stays on, stop driving)
        shut_off_computer = 0;
        keep_driving = 0;
        
        // Override defaults based on conditions
        shut_off_computer = cpu_overheated;
        if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end
    end

endmodule