module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    wire [3:0] input_vec = {a, b, c, d};
    reg out_reg;

    // Truth table implementation
    always @(*) begin
        case(input_vec)
            4'b0010: out_reg = 1'b1;  // 2
            4'b0111: out_reg = 1'b1;  // 7
            4'b1111: out_reg = 1'b1;  // 15
            4'b0000, 4'b0001, 4'b0100, 4'b0101, 4'b0110,
            4'b1001, 4'b1010, 4'b1101, 4'b1110: out_reg = 1'b0;
            default: out_reg = 1'bx;   // don't cares
        endcase
    end

    // SOP form - direct minterm implementation
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d)   |  // 7
                     (a & b & c & d);      // 15

    // POS form - product of complemented maxterms
    assign out_pos = ~(~a | ~b | ~c | ~d) &  // 0
                     ~(~a | ~b | ~c | d)  &  // 1
                     ~(~a | b | ~c | ~d)  &  // 4
                     ~(~a | b | ~c | d)    &  // 5
                     ~(~a | b | c | ~d)    &  // 6
                     ~(a | ~b | ~c | d)    &  // 9
                     ~(a | ~b | c | ~d)    &  // 10
                     ~(a | b | ~c | d)    &  // 13
                     ~(a | b | c | ~d);      // 14

endmodule