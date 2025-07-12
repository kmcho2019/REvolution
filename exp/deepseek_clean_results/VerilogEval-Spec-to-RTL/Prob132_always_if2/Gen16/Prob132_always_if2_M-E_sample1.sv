module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving,
    output     safe_mode
);

    always @(*) begin
        // Default values
        shut_off_computer = 0;
        keep_driving = 0;
        
        // Priority-based assignments
        shut_off_computer = cpu_overheated ? 1 : shut_off_computer;
        keep_driving = (~arrived & ~gas_tank_empty) ? 1 : keep_driving;
    end

    // Additional system health monitoring output
    assign safe_mode = ~(cpu_overheated | (~arrived & gas_tank_empty));

endmodule