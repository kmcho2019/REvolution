module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Internal wire for the direct output
    wire out;

    // LUT implementation using case statement
    always @(*) begin
        case ({a,b,c,d})
            4'b0010: out = 1'b1;  // 2
            4'b0111: out = 1'b1;  // 7
            4'b1111: out = 1'b1;  // 15
            
            4'b0000: out = 1'b0;  // 0
            4'b0001: out = 1'b0;  // 1
            4'b0100: out = 1'b0;  // 4
            4'b0101: out = 1'b0;  // 5
            4'b0110: out = 1'b0;  // 6
            4'b1001: out = 1'b0;  // 9
            4'b1010: out = 1'b0;  // 10
            4'b1101: out = 1'b0;  // 13
            4'b1110: out = 1'b0;  // 14

            // Don't care cases (3,8,11,12) - output doesn't matter
            default: out = 1'bx;
        endcase
    end

    // SOP is direct output
    assign out_sop = out;

    // POS is inverted output (using De Morgan's laws)
    assign out_pos = ~out;

endmodule