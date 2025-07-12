module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Structured always block with explicit defaults
    always @(*) begin
        // Default assignments
        shut_off_computer = 0;
        keep_driving = 0;
        
        // Conditional logic
        if (cpu_overheated) begin
            shut_off_computer = 1;
        end
        
        if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end
    end

endmodule