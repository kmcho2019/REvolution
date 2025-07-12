module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    // The existing XOR-based solution is already quite optimized
    // We can use it as is for simplicity and efficiency
    always @(*) begin
        out = (a ^ b) ^ (c ^ d);
    end

endmodule