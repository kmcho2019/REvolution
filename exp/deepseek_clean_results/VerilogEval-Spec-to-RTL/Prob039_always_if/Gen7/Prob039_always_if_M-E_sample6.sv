module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Priority encoder style selection logic
    wire [1:0] sel_code = {sel_b1, sel_b2};
    wire select_b = (sel_code == 2'b11);  // Only true when both are 1

    // Assign-based implementation
    assign out_assign = select_b ? b : a;

    // Always-based implementation
    reg out_always_reg;
    always @(*) begin
        case (sel_code)
            2'b11: out_always_reg = b;
            default: out_always_reg = a;
        endcase
    end
    assign out_always = out_always_reg;
endmodule