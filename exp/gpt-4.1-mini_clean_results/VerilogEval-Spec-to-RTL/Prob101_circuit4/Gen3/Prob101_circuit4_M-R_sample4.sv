module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output reg  q
);

always @(*) begin
    if (b || c)
        q = 1'b1;
    else
        q = 1'b0;
end

endmodule