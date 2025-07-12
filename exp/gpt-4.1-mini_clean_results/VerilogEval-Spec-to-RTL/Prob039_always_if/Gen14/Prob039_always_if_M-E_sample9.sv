module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    // Continuous assignment implements mux using bitwise logic without intermediate wire
    assign out_assign = (sel_b1 & sel_b2 & b) | (~(sel_b1 & sel_b2) & a);

    // Procedural implementation uses if-else based on combined select condition
    always @(*) begin
        if (sel_b1 & sel_b2)
            out_always = b;
        else
            out_always = a;
    end

endmodule