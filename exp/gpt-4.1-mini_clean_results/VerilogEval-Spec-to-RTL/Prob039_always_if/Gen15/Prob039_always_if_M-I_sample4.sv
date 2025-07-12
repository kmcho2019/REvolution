module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel;

    // Combine select signals into an intermediate wire to reduce redundant logic
    assign sel = sel_b1 & sel_b2;

    // Simplify continuous assignment using ternary operator for clearer mux logic
    assign out_assign = sel ? b : a;

    // Procedural implementation remains the same using the intermediate wire
    always @(*) begin
        if (sel)
            out_always = b;
        else
            out_always = a;
    end

endmodule