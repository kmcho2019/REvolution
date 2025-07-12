module TopModule (
    input wire in,       // Explicit input wire declaration
    output wire out      // Explicit output wire declaration
);
    // Most direct continuous assignment for optimal synthesis
    assign out = ~in;

    /* Technology Note:
     * Let synthesis tool optimize:
     * - Drive strength based on fanout
     * - Vt variant based on timing/power constraints
     * - Standard cell selection
     */
endmodule