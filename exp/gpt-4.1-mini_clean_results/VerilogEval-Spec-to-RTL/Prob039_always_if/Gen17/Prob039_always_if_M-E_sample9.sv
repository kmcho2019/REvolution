module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    // Continuous assignment using combined condition directly
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Procedural assignment with combined condition computed inside always block
    always @(*) begin
        if (sel_b1 & sel_b2) begin
            out_always = b;
        end else begin
            out_always = a;
        end
    end

endmodule