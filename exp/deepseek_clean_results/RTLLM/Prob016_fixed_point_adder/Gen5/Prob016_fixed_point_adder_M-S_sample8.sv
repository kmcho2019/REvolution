module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    wire sign_a = a[N-1];
    wire sign_b = b[N-1];
    wire [N-1:0] sum = a + b;
    wire overflow = (~sign_a & ~sign_b & sum[N-1]) | (sign_a & sign_b & ~sum[N-1]);

    always @(*) begin
        if (overflow) begin
            // Saturate to maximum positive or negative value
            c = sign_a ? {1'b1, {(N-1){1'b0}} : {1'b0, {(N-1){1'b1}}};
        end
        else begin
            c = sum;
        end
    end

endmodule