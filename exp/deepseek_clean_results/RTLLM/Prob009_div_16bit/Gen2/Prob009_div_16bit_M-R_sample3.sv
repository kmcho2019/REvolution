module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

wire [15:0] step_remainder [0:16];
wire [15:0] step_result [0:16];

// Initialize
assign step_remainder[0] = {8'b0, A};
assign step_result[0] = 16'b0;

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : div_step
        wire [16:0] shifted_remainder = {step_remainder[i][14:0], A[15-i]};
        wire [8:0] compare_val = shifted_remainder[16:8];
        wire do_subtract = (B != 0) && (compare_val >= B);
        
        assign step_remainder[i+1] = do_subtract ? 
            {compare_val - B, shifted_remainder[7:0]} : shifted_remainder;
        assign step_result[i+1] = {step_result[i][14:0], do_subtract};
    end
endgenerate

// Handle division by zero case
assign result = (B == 0) ? 16'b0 : step_result[16];
assign odd = (B == 0) ? 16'b0 : step_remainder[16];

endmodule