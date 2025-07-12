module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [size-1:0] mul_a,  // input signal representing the multiplicand
    input [size-1:0] mul_b,  // input signal representing the multiplier
    output reg [2*size-1:0] mul_out  // product output signal
);

// pipeline stages
reg [2*size-1:0] stage1, stage2;

// generate partial products for each bit of the multiplier
wire [2*size-1:0] partial_product [size-1:0];
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_product[i] = (mul_b[i] ? {size'{0}, mul_a} << i : {2*size'{0}});
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= {2*size'{0}};
        stage2 <= {2*size'{0}};
        mul_out <= {2*size'{0}};
    end else begin
        // First stage: calculate partial products for bits 0 and 1
        stage1 <= partial_product[0] + partial_product[1];
        
        // Second stage: calculate partial products for bits 2 and 3, and add to previous result
        stage2 <= stage1 + partial_product[2] + partial_product[3];
        
        // Final product output
        mul_out <= stage2;
    end
end

endmodule