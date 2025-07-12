module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    wire sel_combined = sel_b1 & sel_b2;

    // Continuous assignment mux
    assign out_assign = sel_combined ? b : a;

    // Procedural mux using always block
    always @(*) begin
        if (sel_combined)
            out_always = b;
        else
            out_always = a;
    end

endmodule