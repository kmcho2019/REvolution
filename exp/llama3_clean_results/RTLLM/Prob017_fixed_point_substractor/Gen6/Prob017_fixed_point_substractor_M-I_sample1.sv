module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

always @(a or b) begin
    // Determine the sign of the result
    reg [N-1:0] a_abs, b_abs;
    reg sign_a, sign_b;
    reg [N-1:0] result;
    
    // Calculate absolute values
    a_abs = (a[N-1] == 1'b0) ? a : (~a + 1'b1);
    b_abs = (b[N-1] == 1'b0) ? b : (~b + 1'b1);
    
    // Determine signs
    sign_a = a[N-1];
    sign_b = b[N-1];
    
    // Perform subtraction based on signs
    if (sign_a == sign_b) begin
        // Same sign subtraction
        if (a_abs >= b_abs) begin
            result = a_abs - b_abs;
            c = (sign_a == 1'b0) ? result : (~result + 1'b1);
        end else begin
            result = b_abs - a_abs;
            c = (sign_a == 1'b0) ? (~result + 1'b1) : result;
        end
    end else begin
        // Different sign subtraction
        if (a_abs >= b_abs) begin
            result = a_abs + b_abs;
            c = (sign_a == 1'b0) ? result : (~result + 1'b1);
        end else begin
            result = b_abs + a_abs;
            c = (sign_a == 1'b0) ? (~result + 1'b1) : result;
        end
    end
    
    // Handle zero result
    if (c == 0) begin
        c = {N{1'b0}};
    end
end

endmodule