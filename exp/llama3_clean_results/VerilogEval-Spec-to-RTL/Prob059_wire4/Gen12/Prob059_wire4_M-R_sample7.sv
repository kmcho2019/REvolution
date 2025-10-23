module TopModule(
    input  a,
    input  b,
    input  c,
    output reg w,
    output reg x,
    output reg y,
    output reg z
);

// Using an always block for direct connection
always @(*) begin
    w = a;
    x = b;
    y = b;
    z = c;
end

endmodule