module TopModule (
    output zero  // Permanent LOW output - parameterized implementation
);
    /*
     * Design Rationale:
     * - Parameterized approach for design flexibility
     * - Same PPA benefits as direct assignment (zero delay, minimal power/area)
     * - Centralized constant definition
     * - Demonstrates alternative implementation style
     */
    parameter CONST_ZERO = 1'b0;
    assign zero = CONST_ZERO;
endmodule