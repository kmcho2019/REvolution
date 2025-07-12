module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

wire signed [N-1:0] res;  // Internal signal to hold the result

// Combinational logic for subtraction
always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
    end else begin  // Different signs
        if (a > b) begin
            res = a + (~b + 1);  // Perform subtraction as addition of two's complement
        end else begin
            res = b + (~a + 1);  // Perform subtraction as addition of two's complement
        end
    end
end

// Assign result to output port
assign c = res;

// No explicit handling for overflow and underflow here, as it's typically handled at a higher level or by the synthesizer.

endmodule