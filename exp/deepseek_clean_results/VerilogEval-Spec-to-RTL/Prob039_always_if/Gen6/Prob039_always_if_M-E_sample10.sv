module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Combined select signal
    wire select_b = sel_b1 & sel_b2;

    // Assign-based implementation using ternary operator
    assign out_assign = select_b ? b : a;

    // Always-based implementation using case statement
    reg out_always_reg;
    always @(*) begin
        case (select_b)
            1'b1: out_always_reg = b;
            default: out_always_reg = a;
        endcase
    end
    
    assign out_always = out_always_reg;
endmodule