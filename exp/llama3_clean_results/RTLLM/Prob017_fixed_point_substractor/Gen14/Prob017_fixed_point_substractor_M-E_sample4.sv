module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Define the LUT for common subtraction operations
reg [N-1:0] lut [2**Q-1:0];

// Initialize the LUT
initial begin
    for (int i = 0; i < 2**Q; i++) begin
        lut[i] = {1'b0, Q-1{1'b0}, i};
    end
end

// Input stage: Extract integer and fractional parts
reg [N-Q-1:0] a_int;
reg [Q-1:0] a_frac;
reg [N-Q-1:0] b_int;
reg [Q-1:0] b_frac;

always @(*) begin
    a_int = a[N-1:Q];
    a_frac = a[Q-1:0];
    b_int = b[N-1:Q];
    b_frac = b[Q-1:0];
end

// Subtraction stage: Perform subtraction using conditional statements and LUT
reg [N-1:0] res;
reg sign;

always @(*) begin
    if (a_int[N-Q-1] == b_int[N-Q-1]) begin
        // Same sign subtraction
        res = a_int - b_int;
        sign = a_int[N-Q-1];
    end else begin
        // Different sign subtraction
        if (a_int[N-Q-1] == 1'b0) begin
            // a is positive, b is negative
            res = a_int + (~b_int + 1'b1);
            sign = 1'b0;
        end else begin
            // a is negative, b is positive
            res = (~a_int + 1'b1) + b_int;
            sign = 1'b1;
        end
    end
    
    // Use LUT to handle fractional part subtraction
    res[Q-1:0] = lut[a_frac] - lut[b_frac];
end

// Output stage: Determine sign and output result
always @(*) begin
    if (sign == 1'b0) begin
        c = {1'b0, res[N-1:1]};
    end else begin
        c = {1'b1, res[N-1:1]};
    end
    
    // Handle zero result case
    if (c == 0) begin
        c = 0;
    end
end

endmodule