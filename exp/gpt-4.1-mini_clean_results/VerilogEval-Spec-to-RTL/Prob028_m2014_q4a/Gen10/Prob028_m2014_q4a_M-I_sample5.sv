module TopModule(
    input wire d,
    input wire ena,
    output reg q
);

always @(*) begin
    if (ena)
        q = d;
    // else q keeps its old value (latch inferred)
end

endmodule