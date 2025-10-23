module TopModule (
    input  [99:0] in,
    output reg    out_and,  // Output is 1 only if all 100 input bits are 1 (100-input AND)
    output reg    out_or,   // Output is 1 if any one or more of the 100 input bits is 1 (100-input OR)
    output reg    out_xor   // Output is the parity of the 100 input bits (100-input XOR)
);

    integer i;
    always @(*) begin
        // Initialize outputs for reduction computations
        out_and = 1'b1;
        out_or  = 1'b0;
        out_xor = 1'b0;

        // Perform bitwise reduction by iterating over input bits
        for (i = 0; i < 100; i = i + 1) begin
            out_and = out_and & in[i];
            out_or  = out_or  | in[i];
            out_xor = out_xor ^ in[i];
        end
    end

endmodule