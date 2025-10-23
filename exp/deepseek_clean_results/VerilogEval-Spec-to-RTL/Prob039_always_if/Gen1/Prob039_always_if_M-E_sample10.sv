module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);

    // Combine select signals into 2-bit value
    wire [1:0] sel_combined = {sel_b1, sel_b2};

    // Implementation using assign with LUT approach
    assign out_assign = (~sel_combined[1] | ~sel_combined[0]) ? a : b;

    // Implementation using always block with case statement
    reg out_always_reg;
    always @(*) begin
        case (sel_combined)
            2'b11: out_always_reg = b;  // Only case where we select b
            default: out_always_reg = a; // All other cases select a
        endcase
    end
    assign out_always = out_always_reg;

endmodule