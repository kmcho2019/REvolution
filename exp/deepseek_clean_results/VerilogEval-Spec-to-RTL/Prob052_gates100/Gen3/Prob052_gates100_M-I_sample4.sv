module TopModule (
    input [99:0] in,       // 100-bit input vector
    output out_and,         // AND reduction of all inputs (1 when all bits are 1)
    output out_or,          // OR reduction of all inputs (1 when any bit is 1)
    output out_xor          // XOR reduction of all inputs (1 when odd number of bits are 1)
);

    // Using Verilog reduction operators which synthesize efficiently into tree structures
    // Synthesis tools will automatically optimize these into balanced trees
    assign out_and = &in;  // Equivalent to in[0] & in[1] & ... & in[99]
    assign out_or  = |in;  // Equivalent to in[0] | in[1] | ... | in[99]
    assign out_xor = ^in;  // Equivalent to in[0] ^ in[1] ^ ... ^ in[99]

    /* Alternative hierarchical approach (commented out as it typically doesn't improve PPA)
    // First level reduction (groups of 10)
    wire [9:0] and_grp, or_grp, xor_grp;
    genvar i;
    generate
        for (i=0; i<10; i=i+1) begin : reduce
            assign and_grp[i] = &in[i*10 +: 10];
            assign or_grp[i]  = |in[i*10 +: 10];
            assign xor_grp[i] = ^in[i*10 +: 10];
        end
    endgenerate
    
    // Final reduction
    assign out_and = &and_grp;
    assign out_or  = |or_grp;
    assign out_xor = ^xor_grp;
    */

endmodule