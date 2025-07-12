module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);

    // Bitwise operation implementation
    wire select = sel_b1 & sel_b2;
    assign out_assign = (a & ~select) | (b & select);

    // Case statement implementation
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_always = b;
            default: out_always = a;
        endcase
    end

endmodule