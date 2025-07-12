module TopModule (
    input  a,
    input  b,
    input  c,
    output reg out
);
    // Procedural combinational logic inside always block
    always @(*) begin
        out <= a | b | c;
    end
endmodule