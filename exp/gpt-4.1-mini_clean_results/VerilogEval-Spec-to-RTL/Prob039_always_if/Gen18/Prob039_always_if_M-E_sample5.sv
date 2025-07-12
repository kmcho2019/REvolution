module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel_b;
    assign sel_b = sel_b1 & sel_b2;

    // Continuous assignment mux
    assign out_assign = sel_b ? b : a;

    // Procedural mux using always block with if statement
    always @(*) begin
        if (sel_b) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end

endmodule