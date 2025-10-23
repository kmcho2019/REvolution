module TopModule (
    output zero  // Permanent LOW output - optimal PPA implementation
);
    /*
     * Design Rationale:
     * - Direct assignment provides zero propagation delay
     * - No switching activity minimizes power consumption
     * - Single connection minimizes area
     * - Functionally equivalent to more complex implementations
     */
    assign zero = 1'b0;
endmodule