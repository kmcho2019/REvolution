module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

wire [15:0] quotient;
wire [15:0] remainder [0:15];
wire [15:0] partial_remainder [0:15];
wire [15:0] divisor_ext = {8'b0, B};

// Generate partial remainders and quotient bits in parallel
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : div_stage
        // Compute initial partial remainder (A shifted left by i bits)
        wire [15:0] shifted_A = A << i;
        
        // Compute potential new remainder (current - divisor)
        wire [15:0] sub_result = (i == 0) ? shifted_A : remainder[i-1];
        wire [15:0] new_remainder = sub_result - divisor_ext;
        
        // Determine quotient bit (1 if subtraction doesn't underflow)
        assign quotient[15-i] = ~new_remainder[15];
        
        // Select remainder (either new or original)
        assign partial_remainder[i] = quotient[15-i] ? new_remainder : sub_result;
        
        // Propagate remainder with prefix computation
        if (i == 0) begin
            assign remainder[i] = partial_remainder[i];
        end else begin
            // Parallel prefix computation for remainder propagation
            assign remainder[i] = quotient[15-i] ? partial_remainder[i] : 
                                (remainder[i-1] << 1) | (A[15-i] ? 16'b1 : 16'b0);
        end
    end
endgenerate

// Final outputs
assign result = quotient;
assign odd = remainder[15];

endmodule