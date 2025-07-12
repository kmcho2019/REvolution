module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    output logic [N-1:0] c
);

logic [N-1:0] res;

// Determine the sign of the inputs
logic sign_a = a[N-1];
logic sign_b = b[N-1];

// Perform subtraction based on signs
always_comb begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (sign_a == 1'b0) begin
            // a is positive, b is negative
            res = a + (~b + 1'b1);
        end else begin
            // a is negative, b is positive
            res = (~a + 1'b1) + b;
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule