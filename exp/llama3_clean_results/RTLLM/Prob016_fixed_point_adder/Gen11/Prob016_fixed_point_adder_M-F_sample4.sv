module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Simplified absolute value calculation
wire [N-1:0] abs_a = (sign_a) ? (~a + 1) : a;
wire [N-1:0] abs_b = (sign_b) ? (~b + 1) : b;

// Streamlined combinational logic
reg [N-1:0] result;
always @(*) begin
    if (sign_a == sign_b) begin
        // Addition of absolute values
        result = abs_a + abs_b;
    end else begin
        // Subtraction of absolute values
        result = (abs_a > abs_b) ? (abs_a - abs_b) : (abs_b - abs_a);
    end
end

// Improved overflow handling and sign determination
always @(*) begin
    if (result[N-1] == 1'b1) begin // Overflow
        c = (sign_a) ? {N{1'b1}} : {N{1'b0}};
    end else begin
        // Set the sign of the result based on the signs of the operands
        c = (sign_a == sign_b) ? result : ((abs_a > abs_b) ? result : {~result[N-1], result[N-2:0]} + 1);
    end
end

endmodule