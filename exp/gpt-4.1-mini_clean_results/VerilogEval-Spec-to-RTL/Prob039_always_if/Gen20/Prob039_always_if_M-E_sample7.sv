module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    // Internal wire for combined select
    wire sel_final;

    assign sel_final = sel_b1 & sel_b2;

    // Continuous assignment for out_assign using boolean expressions
    // out_assign = (sel_final & b) | (~sel_final & a);
    assign out_assign = (sel_final & b) | (~sel_final & a);

    // Procedural assignment for out_always using always_comb and if-else
    always @(*) begin
        if (sel_final)
            out_always = b;
        else
            out_always = a;
    end

endmodule