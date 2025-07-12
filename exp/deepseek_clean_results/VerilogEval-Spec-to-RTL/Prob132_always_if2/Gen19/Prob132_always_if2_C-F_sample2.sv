module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving
);

    // Thermal control (default: 0 = computer running)
    assign shut_off_computer = cpu_overheated ? 1'b1 : 1'b0;

    // Driving logic (default: 0 = don't drive)
    // Only drive if: not arrived AND tank not empty
    assign keep_driving = (~arrived) & (~gas_tank_empty);

    /* Design Advantages:
     * 1. No procedural blocks = no risk of incomplete assignments
     * 2. Explicit defaults in ternary operators
     * 3. Clear one-line implementations for each function
     * 4. Optimal combinational logic structure
     * 5. Easier to modify than either original solution
     */
endmodule