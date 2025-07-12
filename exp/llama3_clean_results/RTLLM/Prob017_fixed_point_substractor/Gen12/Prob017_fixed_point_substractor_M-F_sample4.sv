module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res;  // Internal register to hold the result

// Explicitly handle edge cases and synthesizability
always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
    end else begin  // Different signs
        if (a > b) begin
            res = a - b;
        end else begin
            res = b - a;
            // Handle negative result explicitly
            if (res == 0) begin
                res = 0;  // Set to zero if result is zero
            end else begin
                res = -res;  // Invert sign if necessary
            end
        end
    end
    
    // Handle overflow and underflow explicitly
    if (res > {({N-1{1'b1}}, {Q{1'b0}})}) begin  // Overflow check
        res = {({N-1{1'b1}}, {Q{1'b0}})};  // Saturate at maximum value
    end else if (res < -({({N-1{1'b1}}, {Q{1'b0}})})) begin  // Underflow check
        res = -({({N-1{1'b1}}, {Q{1'b0}})});  // Saturate at minimum value
    end
end

assign c = res;  // Assign result to output port

endmodule