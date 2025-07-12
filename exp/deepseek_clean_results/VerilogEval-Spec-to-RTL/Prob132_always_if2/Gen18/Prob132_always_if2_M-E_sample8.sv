module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Thermal Control Unit
    always @(*) begin
        shut_off_computer = 1'b0; // Default: computer running
        if (cpu_overheated) begin
            shut_off_computer = 1'b1; // Override: shutdown
        end
    end

    // Driving Control Unit
    always @(*) begin
        keep_driving = 1'b0; // Default: don't drive
        if (!arrived) begin  // Only consider driving if not at destination
            keep_driving = !gas_tank_empty; // Drive if we have fuel
        end
    end

    /* Architectural Advantages:
     * 1. Clear separation of concerns between subsystems
     * 2. Default states prevent undefined behavior
     * 3. Easier to add additional conditions later
     * 4. More closely models physical system behavior
     * 
     * Optimization Notes:
     * - Could parameterize default states
     * - Could add intermediate "warning" states
     * - Easy to convert to clocked logic if needed
     */
endmodule