module TopModule (
    input  wire a,
    input  wire b,
    output reg  out
);

always @(*) begin
    if (a == 1'b1 && b == 1'b1)
        out = 1'b1;
    else
        out = 1'b0;
end

endmodule