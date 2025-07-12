module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);

    // Bitwise implementation for continuous assignment
    wire combined_sel = sel_b1 & sel_b2;
    assign out_assign = (a & ~combined_sel) | (b & combined_sel);

    // Case statement implementation for procedural block
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_always = b;
            default: out_always = a;
        endcase
    end

endmodule