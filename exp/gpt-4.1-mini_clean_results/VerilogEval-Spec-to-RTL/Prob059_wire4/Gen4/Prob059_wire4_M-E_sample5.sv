module TopModule(
    input wire a,
    input wire b,
    input wire c,
    output reg w,
    output reg x,
    output reg y,
    output reg z
);

    always @(*) begin
        w = a;
        x = b;
        y = b;
        z = c;
    end

endmodule