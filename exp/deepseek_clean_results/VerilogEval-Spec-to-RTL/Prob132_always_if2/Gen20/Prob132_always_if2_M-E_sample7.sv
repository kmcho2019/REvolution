module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Thermal management system
    always @(cpu_overheated) begin
        shut_off_computer = 1'b0;  // Default: computer stays on
        if (cpu_overheated) begin
            shut_off_computer = 1'b1;  // Emergency shutdown
        end
    end

    // Vehicle control system
    always @(arrived, gas_tank_empty) begin
        keep_driving = 1'b0;  // Default: stop driving
        if (!arrived && !gas_tank_empty) begin
            keep_driving = 1'b1;  // Continue driving if needed and possible
        end
    end

endmodule