module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Assign version using logical OR of AND conditions
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Always version implemented as a lookup table
    reg out_reg;
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_reg = b;  // Both select signals high
            default: out_reg = a; // All other cases
        endcase
    end
    assign out_always = out_reg;
endmodule