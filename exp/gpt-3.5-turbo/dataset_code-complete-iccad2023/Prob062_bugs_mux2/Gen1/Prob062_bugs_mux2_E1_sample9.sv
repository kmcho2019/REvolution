module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
);

// Convert single bit signal sel to 8-bit for bitwise negation
wire [7:0] sel_8 = {sel, sel, sel, sel, sel, sel, sel, sel};

always @* begin
    out = (~sel_8 & a) | (sel_8 & b);
end

endmodule