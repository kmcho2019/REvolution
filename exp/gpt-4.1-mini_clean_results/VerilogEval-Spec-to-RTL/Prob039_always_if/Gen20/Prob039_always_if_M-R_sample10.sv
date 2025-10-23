module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output reg  out_always,
    output wire out_assign
);
    wire sel_final;
    assign sel_final = sel_b1 & sel_b2;

    always @(*) begin
        if (sel_final)
            out_always = b;
        else
            out_always = a;
    end

    assign out_assign = out_always;

endmodule