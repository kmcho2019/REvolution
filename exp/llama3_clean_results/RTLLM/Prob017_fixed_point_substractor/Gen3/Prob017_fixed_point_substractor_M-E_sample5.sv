module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Define the LUTs for precomputed subtraction results
reg signed [N-1:0] lut [2**Q - 1:0];

// Initialize the LUTs
initial begin
    for (int i = 0; i < 2**Q; i++) begin
        // Calculate the precomputed result for each segment
        lut[i] = i - (2**Q / 2);
    end
end

// Calculate the index for the LUT
wire [Q-1:0] index_a = a[N-1-Q:N];
wire [Q-1:0] index_b = b[N-1-Q:N];

// Determine the signs of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Core computation stage
always @(*) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        c = a - b;
    end else begin
        // Different sign subtraction
        if (a > b) begin
            c = a + (~b + 1);
        end else begin
            c = (~a + 1) + b;
        end
    end
    
    // Handle zero result
    if (c == 0) begin
        c = 0;
    end
end

// Alternative LUT-based implementation
// reg signed [N-1:0] lut_result;
// always @(*) begin
//     lut_result = lut[index_a] - lut[index_b];
//     if (sign_a == sign_b) begin
//         c = lut_result;
//     end else begin
//         c = lut_result + (sign_a? -1 : 1);
//     end
// end

endmodule