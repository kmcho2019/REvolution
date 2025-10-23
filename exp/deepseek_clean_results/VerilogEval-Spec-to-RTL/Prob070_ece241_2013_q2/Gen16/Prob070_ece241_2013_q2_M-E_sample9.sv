module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Internal signal that serves as the truth table
    reg lut_out;

    // 4-input LUT implementation
    always @(*) begin
        case ({a,b,c,d})
            4'b0000: lut_out = 1'b0;  // 0
            4'b0001: lut_out = 1'b0;  // 1
            4'b0010: lut_out = 1'b1;  // 2
            4'b0011: lut_out = 1'b0;  // 3 (don't care)
            4'b0100: lut_out = 1'b0;  // 4
            4'b0101: lut_out = 1'b0;  // 5
            4'b0110: lut_out = 1'b0;  // 6
            4'b0111: lut_out = 1'b1;  // 7
            4'b1000: lut_out = 1'b0;  // 8 (don't care)
            4'b1001: lut_out = 1'b0;  // 9
            4'b1010: lut_out = 1'b0;  // 10
            4'b1011: lut_out = 1'b0;  // 11 (don't care)
            4'b1100: lut_out = 1'b0;  // 12 (don't care)
            4'b1101: lut_out = 1'b0;  // 13
            4'b1110: lut_out = 1'b0;  // 14
            4'b1111: lut_out = 1'b1;  // 15
            default: lut_out = 1'b0;   // catch-all
        endcase
    end

    // Both outputs come from the same LUT for consistency
    assign out_sop = lut_out;
    assign out_pos = lut_out;

endmodule