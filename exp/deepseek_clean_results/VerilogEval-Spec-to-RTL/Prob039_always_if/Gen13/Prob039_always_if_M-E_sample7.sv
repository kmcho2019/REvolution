module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Assign version using bitwise OR and ternary operator
    assign out_assign = (sel_b1 && sel_b2) ? b : a;

    // Always version using case statement
    reg out_reg;
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_reg = b;
            default: out_reg = a;
        endcase
    end
    assign out_always = out_reg;
endmodule