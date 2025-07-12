module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

wire [16:0] partial_remainder [0:15]; // 17 bits: [16:8] for comparison, [7:0] for shifted bits
wire [15:0] quotient_bits;

genvar i;

// Initialize first stage
assign partial_remainder[0] = {9'b0, A[15:8]}; // Start with upper 8 bits of dividend

generate
    for (i = 0; i < 16; i = i + 1) begin : div_stage
        wire [16:0] shifted_remainder = {partial_remainder[i][15:0], A[15-i]}; // Shift left and append next bit
        
        // Comparison and subtraction
        assign quotient_bits[15-i] = (shifted_remainder[16:8] >= B) ? 1'b1 : 1'b0;
        assign partial_remainder[i+1] = (shifted_remainder[16:8] >= B) ? 
                                       {shifted_remainder[16:8] - B, shifted_remainder[7:0]} : 
                                       shifted_remainder;
    end
endgenerate

assign result = quotient_bits;
assign odd = partial_remainder[16][15:0]; // Final remainder

endmodule