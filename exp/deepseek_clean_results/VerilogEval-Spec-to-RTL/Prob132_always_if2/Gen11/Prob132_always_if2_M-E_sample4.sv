module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Priority-encoded control logic
    always @(*) begin
        // Default assignments
        shut_off_computer = 1'b0;
        keep_driving = 1'b0;
        
        // Priority 1: Safety - overheating
        if (cpu_overheated) begin
            shut_off_computer = 1'b1;
            keep_driving = 1'b0;  // Explicitly turn off driving if overheating
        end
        // Priority 2: Operational status
        else if (~arrived) begin
            keep_driving = ~gas_tank_empty;
        end
    end

endmodule