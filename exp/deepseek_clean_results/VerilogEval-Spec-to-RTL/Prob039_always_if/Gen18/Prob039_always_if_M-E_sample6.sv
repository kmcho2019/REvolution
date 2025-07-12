module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Bitmask approach for assign statement
    wire select_mask = sel_b1 & sel_b2;
    assign out_assign = (a & ~select_mask) | (b & select_mask);

    // Case statement approach for always block
    reg out_always_reg;
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_always_reg = b;
            default: out_always_reg = a;
        endcase
    end
    assign out_always = out_always_reg;
endmodule