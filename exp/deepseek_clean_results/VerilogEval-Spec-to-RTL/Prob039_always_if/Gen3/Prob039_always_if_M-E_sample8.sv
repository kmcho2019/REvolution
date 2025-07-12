module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);

    // Continuous assignment using gate-level implementation
    wire sel_both = sel_b1 & sel_b2;
    wire a_path = a & ~sel_both;
    wire b_path = b & sel_both;
    assign out_assign = a_path | b_path;

    // Procedural implementation using case statement
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_always = b;
            default: out_always = a;
        endcase
    end

endmodule