module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    // Internal signals
    wire signed [N-1:0] sum;
    wire signed [N-1:0] diff;
    wire overflow;

    // Calculate sum and detect overflow
    assign sum = a + b;
    assign overflow = (a[N-1] == b[N-1]) && (sum[N-1] != a[N-1]);

    // Calculate difference when signs differ
    assign diff = (a > b) ? (a - b) : (b - a);

    always @(*) begin
        if (a[N-1] == b[N-1]) begin
            // Same sign case
            if (overflow) begin
                // Saturate to max positive or negative
                c = {a[N-1], {(N-1){~a[N-1]}};
            end else begin
                c = sum;
            end
        end else begin
            // Different signs case
            c = (a > b) ? {a[N-1], diff[N-2:0]} : {b[N-1], diff[N-2:0]};
        end
    end

endmodule