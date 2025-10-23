module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);
    wire sel_final = sel_b1 & sel_b2;

    // Continuous assignment for out_assign using ternary operator
    assign out_assign = sel_final ? b : a;

    // Procedural assignment for out_always using if statement
    always @(*) begin
        if (sel_final)
            out_always = b;
        else
            out_always = a;
    end
endmodule