module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output reg  out
);

always @(*) begin
    if (sel == 1'b0)
        out = a;
    else
        out = b;
end

endmodule