module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    always @(*) begin
        // Directly compute output based on XOR results without intermediate signals
        out = (a ^ b) ^ (c ^ d);
    end

endmodule