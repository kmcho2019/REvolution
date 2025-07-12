module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Directly perform subtraction, handling signs and overflow
reg signed [N:0] result;
always @(*) begin
    result = a - b;
    
    // Handle overflow by saturating to maximum/minimum representable value
    if (result[N] == 1'b1) begin
        // Overflow, saturate to maximum negative value
        c = {1'b1, {N-1{1'b1}}};
    end else if (result[N] == 1'b0 && result[N-1] == 1'b1) begin
        // Negative result, check for underflow
        if (result[N-1:0] == {N{1'b0}}) begin
            c = {N{1'b0}}; // Underflow, set to 0
        end else begin
            c = result[N-1:0];
        end
    end else begin
        // Positive result or zero, assign directly
        c = result[N-1:0];
    end
end

endmodule