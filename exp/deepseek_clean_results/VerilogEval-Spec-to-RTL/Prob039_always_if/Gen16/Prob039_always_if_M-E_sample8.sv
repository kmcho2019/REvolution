module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Priority-encoded continuous assignment
    assign out_assign = (sel_b1 && sel_b2) ? b : a;

    // Priority-encoded procedural implementation
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_always = b;  // Both select signals high
            default: out_always = a; // All other cases
        endcase
    end
endmodule