module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    // Continuous assignment 2-to-1 mux without intermediate wire
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Procedural 2-to-1 mux with if statement without intermediate wire
    always @(*) begin
        if (sel_b1 & sel_b2)
            out_always = b;
        else
            out_always = a;
    end

endmodule