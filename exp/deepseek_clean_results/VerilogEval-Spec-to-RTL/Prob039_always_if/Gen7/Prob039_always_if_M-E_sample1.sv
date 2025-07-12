module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    // Assign implementation using hierarchical ternary
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Always block implementation with nested ternary
    always @(*) begin
        out_always = sel_b1 ? (sel_b2 ? b : a) : a;
    end

    /* Alternative implementation showing different coding styles:
    // Option 1: Explicit if-else
    always @(*) begin
        if (sel_b1 & sel_b2)
            out_always = b;
        else
            out_always = a;
    end

    // Option 2: Case statement
    always @(*) begin
        case ({sel_b1, sel_b2})
            2'b11: out_always = b;
            default: out_always = a;
        endcase
    end
    */
endmodule