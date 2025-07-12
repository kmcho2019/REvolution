module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire [N-1:0] sum_raw;
    wire overflow;

    // Simple two's complement addition
    assign sum_raw = a + b;

    // Overflow detection: 
    // If signs of inputs are same but differ from result
    assign overflow = (a[N-1] == b[N-1]) && (sum_raw[N-1] != a[N-1]);

    // Result selection with saturation
    always @(*) begin
        if (overflow) begin
            // Saturate to maximum positive or negative value
            c = a[N-1] ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
        end else begin
            c = sum_raw;
        end
    end

endmodule