module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

// Precompute zero-extended divisor
wire [15:0] divisor_ext = {8'b0, B};

// Parallel computation nodes
wire [15:0] partial_remainder [0:15];
wire [15:0] quotient_bits;

// Division by zero detection
wire div_by_zero = (B == 8'b0);

// First stage: compute initial partial remainders
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : div_stage
        // Current remainder candidate (shifted by 1 and new bit)
        wire [15:0] current_rem = (i == 0) ? {15'b0, A[15]} : 
                                {partial_remainder[i-1][14:0], A[15-i]};
        
        // Comparison and remainder update
        assign quotient_bits[i] = (current_rem >= divisor_ext) || div_by_zero;
        assign partial_remainder[i] = quotient_bits[i] ? 
                                     (current_rem - divisor_ext) : current_rem;
    end
endgenerate

// Output assignment
always @(*) begin
    if (div_by_zero) begin
        result = 16'hFFFF;
        odd = 16'hFFFF;
    end else begin
        result = quotient_bits;
        odd = partial_remainder[15];
    end
end

endmodule