module TopModule(
    input  a,
    input  b,
    input  sel,
    output reg out
);
// Implement the multiplexer using an always block for a procedural description
always @(*) begin
    if (sel) begin
        out = b;
    end else begin
        out = a;
    end
end
endmodule