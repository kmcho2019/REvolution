module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    wire sel_final = sel_b1 & sel_b2;

    // Continuous assign for out_assign (combinational mux)
    assign out_assign = sel_final ? b : a;

    // Procedural mux implementation for out_always using always block
    always @(*) begin
        if (sel_final)
            out_always = b;
        else
            out_always = a;
    end

endmodule