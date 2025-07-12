module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

wire [N-1:0] sum;
wire [N-1:0] diff_ab;
wire [N-1:0] diff_ba;
wire is_overflow;

assign sum = a + b;
assign diff_ab = a - b;
assign diff_ba = b - a;

assign is_overflow = (sum >= (1 << N)) || (diff_ab < 0) || (diff_ba < 0);

always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Same signs, add absolute values
        if (is_overflow) begin
            c = (1 << N) - 1;
        end else begin
            c = sum;
        end
    end else begin
        // Different signs, subtract
        if (a[N-1] == 1'b0) begin
            // a is positive, b is negative
            if (diff_ab < 0) begin
                c = 0;
            end else begin
                c = diff_ab;
            end
        end else begin
            // a is negative, b is positive
            if (diff_ba < 0) begin
                c = (1 << N) - 1; // Assuming two's complement representation
            end else begin
                c = diff_ba;
            end
        end
    end
end

endmodule