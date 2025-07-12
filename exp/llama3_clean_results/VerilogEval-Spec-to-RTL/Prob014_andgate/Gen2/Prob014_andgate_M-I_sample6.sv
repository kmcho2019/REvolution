module TopModule(
    input  a,
    input  b,
    output reg out
);

always @(*) begin
    out = a & b;
end

initial begin
    out = 1'b0; // Initialize output to a known state
end

endmodule