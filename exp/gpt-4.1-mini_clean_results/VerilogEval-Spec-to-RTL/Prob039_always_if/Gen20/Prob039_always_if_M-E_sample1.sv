module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel = sel_b1 & sel_b2;

    // Continuous assignment for out_assign using inline mux logic
    assign out_assign = sel ? b : a;

    // Procedural if-else mux implementation for out_always
    always @(*) begin
        if (sel) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end

endmodule