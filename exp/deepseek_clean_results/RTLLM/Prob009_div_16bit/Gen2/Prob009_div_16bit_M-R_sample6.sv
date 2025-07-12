module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

wire [15:0] quotient;
wire [15:0] remainder;
wire div_by_zero = (B == 8'b0);

// Intermediate remainder registers for each step
wire [16:0] rem_stage [0:16];  // 17 bits (16 + carry) for each stage

// Initialize first stage
assign rem_stage[0] = {1'b0, A};

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : div_stages
        wire [16:0] shifted_rem = rem_stage[i] << 1;
        wire [8:0] upper_bits = shifted_rem[16:8];
        wire do_subtract = (upper_bits >= {1'b0, B}) && !div_by_zero;
        
        assign rem_stage[i+1] = do_subtract ? 
            {upper_bits - B, shifted_rem[7:0]} : shifted_rem;
        assign quotient[15-i] = do_subtract;
    end
endgenerate

// Final outputs
assign result = div_by_zero ? 16'hFFFF : quotient;
assign odd = div_by_zero ? 16'b0 : rem_stage[16][15:0];

endmodule