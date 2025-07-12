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

wire [N-1:0] abs_a = sign_a ? {~a[N-1], a[N-2:0]} + 1 : a;
wire [N-1:0] abs_b = sign_b ? {~b[N-1], b[N-2:0]} + 1 : b;

reg [N:0] result;
always @(*) begin
    if (sign_a == sign_b) begin
        // Addition of absolute values
        result = abs_a + abs_b;
    end else begin
        // Subtraction of absolute values
        if (abs_a > abs_b) begin
            result = abs_a - abs_b;
        end else begin
            result = abs_b - abs_a;
        end
    end
end

always @(*) begin
    if (result[N]) begin // Overflow
        if (sign_a) begin
            c = {N{1'b1}};
        end else begin
            c = {N{1'b0}};
        end
    end else begin
        // Set the sign of the result
        if ((sign_a == sign_b && result[N-1] == 1'b1) || (sign_a != sign_b && abs_a < abs_b)) begin
            c = {~result[N-1], result[N-2:0]} + 1;
        end else begin
            c = result[N-1:0];
        end
    end
end

endmodule