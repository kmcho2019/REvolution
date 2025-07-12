module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

wire [15:0] divisor_ext = {8'b0, B};
wire [15:0] steps [0:16];
wire [15:0] rem_steps [0:16];
wire [15:0] quot_bits;

// Initialize
assign steps[0] = A;
assign rem_steps[0] = 16'b0;

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : div_steps
        wire [15:0] rem_shifted = {rem_steps[i][14:0], steps[i][15-i]};
        wire cmp = rem_shifted >= divisor_ext;
        
        assign rem_steps[i+1] = cmp ? (rem_shifted - divisor_ext) : rem_shifted;
        assign quot_bits[15-i] = cmp;
        assign steps[i+1] = steps[i];  // Pass through remaining bits
    end
endgenerate

// Handle division by zero
assign result = (B == 8'b0) ? 16'hFFFF : quot_bits;
assign odd = (B == 8'b0) ? 16'hFFFF : rem_steps[16];

endmodule