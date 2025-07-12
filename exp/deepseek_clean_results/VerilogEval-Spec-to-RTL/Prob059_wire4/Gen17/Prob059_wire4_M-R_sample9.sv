module TopModule (
    input  a,
    input  b,
    input  c,
    output reg w,
    output reg x,
    output reg y,
    output reg z
);
    always @(*) begin
        // Procedural assignments for all outputs
        w = a;
        x = b;
        y = b;
        z = c;
    end
endmodule