module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Optimal implementation using 4-input XNOR
    assign q = ~(a ^ b ^ c ^ d);

    /* Verification infrastructure (not synthesized)
    // Truth table verification
    always @(*) begin
        case ({d,c,b,a})
            4'b0000: assert (q == 1'b1);
            4'b0001: assert (q == 1'b0);
            4'b0010: assert (q == 1'b0);
            4'b0011: assert (q == 1'b1);
            4'b0100: assert (q == 1'b0);
            4'b0101: assert (q == 1'b1);
            4'b0110: assert (q == 1'b1);
            4'b0111: assert (q == 1'b0);
            4'b1000: assert (q == 1'b0);
            4'b1001: assert (q == 1'b1);
            4'b1010: assert (q == 1'b1);
            4'b1011: assert (q == 1'b0);
            4'b1100: assert (q == 1'b1);
            4'b1101: assert (q == 1'b0);
            4'b1110: assert (q == 1'b0);
            4'b1111: assert (q == 1'b1);
        endcase
    end
    */

endmodule