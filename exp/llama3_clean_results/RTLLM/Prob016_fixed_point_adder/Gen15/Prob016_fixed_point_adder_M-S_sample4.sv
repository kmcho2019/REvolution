module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a + b;
    end else begin // Different signs
        if (a > b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
end

assign c = res;

endmodule