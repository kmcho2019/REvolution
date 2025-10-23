module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

// Division by zero flag
wire div_by_zero = (B == 8'b0);

// Intermediate remainder signals
wire [16:0] rem [0:16];  // 17-bit remainders (16 + carry)

// Initialize first remainder
assign rem[0] = {1'b0, A};

// Generate division steps
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : div_steps
        wire [8:0] cmp_val = rem[i][16:8];  // Upper 9 bits for comparison
        wire do_subtract = ~div_by_zero & (cmp_val >= {1'b0, B});
        wire [8:0] new_upper = do_subtract ? (cmp_val - B) : cmp_val;
        
        assign rem[i+1] = {new_upper, rem[i][7:0], 1'b0} >> 1;
        assign result[15-i] = do_subtract;
    end
endgenerate

// Final outputs
assign odd = div_by_zero ? 16'b0 : rem[16][16:1];
assign result = div_by_zero ? 16'hFFFF : result;

endmodule