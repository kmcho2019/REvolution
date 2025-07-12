module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Assign-based implementation with nested ternary
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Always-based implementation with case statement
    reg out_always_reg;
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_always_reg = b;
            default: out_always_reg = a;
        endcase
    end
    assign out_always = out_always_reg;
endmodule