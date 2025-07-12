module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    // Compute combined select once to reduce redundant logic
    wire sel_b = sel_b1 & sel_b2;

    // Continuous assignment mux output
    assign out_assign = sel_b ? b : a;

    // Procedural mux output using if-else
    always @(*) begin
        if (sel_b)
            out_always = b;
        else
            out_always = a;
    end

endmodule