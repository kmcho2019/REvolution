module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,    // d is unused in this logic
    output reg  q
);

always @(*) begin
    q = b | c;
end

endmodule