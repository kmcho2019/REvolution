module TopModule(
    input  a,
    input  b,
    input  c,
    output reg w,
    output reg x,
    output reg y,
    output reg z
);
    // Directly assign inputs to outputs
    always @(*) begin
        w = a;
        x = b;
        y = b;
        z = c;
    end
endmodule