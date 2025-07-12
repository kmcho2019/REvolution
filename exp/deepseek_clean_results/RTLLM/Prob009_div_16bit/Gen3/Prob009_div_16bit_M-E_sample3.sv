module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

// Early termination for division by zero
wire div_by_zero = (B == 8'b0);
assign result = div_by_zero ? 16'hFFFF : quotient;
assign odd = div_by_zero ? 16'b0 : final_remainder;

// Parallel computation of all possible remainders
wire [8:0] B_ext = {1'b0, B};
wire [8:0] remainder_diff [0:15];
wire [15:0] quotient_bits;

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : div_tree
        // Current partial remainder (9 bits)
        wire [8:0] current_rem = (i == 0) ? {1'b0, A[15:8]} : 
                                {remainder_diff[i-1][7:0], A[15-i]};
        
        // Compute difference in parallel
        wire [8:0] diff = current_rem - B_ext;
        
        // Quotient bit decision
        assign quotient_bits[i] = ~diff[8]; // MSB indicates negative
        
        // Select next remainder
        assign remainder_diff[i] = quotient_bits[i] ? diff : current_rem;
    end
endgenerate

// Final results
wire [15:0] quotient = {quotient_bits[7:0], quotient_bits[15:8]};
wire [15:0] final_remainder = {8'b0, remainder_diff[15][7:0]};

endmodule