module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Sign Extraction Unit (SEU)
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Absolute Value Generator (AVG)
wire [N-1:0] abs_a = (sign_a == 1'b0) ? a : (~a + 1'b1);
wire [N-1:0] abs_b = (sign_b == 1'b0) ? b : (~b + 1'b1);

// Shared Adder/Subtractor Unit with Overflow Detection
reg [N:0] res;
always @(*) begin
    if (sign_a == sign_b) begin
        // Absolute Value Addition
        res = abs_a + abs_b;
    end else begin
        // Absolute Value Subtraction
        if (abs_a >= abs_b) begin
            res = abs_a - abs_b;
        end else begin
            res = abs_b - abs_a;
        end
    end
end

// Overflow Detection and Correction Unit (ODCU)
assign c = (res[N] == 1'b1) ? {sign_a, {N-1{1'b0}}} : res[N-1:0];

endmodule