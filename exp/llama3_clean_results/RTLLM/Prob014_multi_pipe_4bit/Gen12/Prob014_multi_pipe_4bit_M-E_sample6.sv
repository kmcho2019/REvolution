module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// declare the registers for the intermediate results
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

// generate the partial products and calculate the product
always @(*) begin
    stage1_reg = 8'd0;
    for (int i = 0; i < size; i++) begin
        if (mul_b[i] == 1'b1) begin
            stage1_reg = stage1_reg + ({4'b0, mul_a} << i);
        end
    end
end

// update the registers and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset the registers and output
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // update the stage1 register
        stage2_reg <= stage1_reg;
        
        // update the output
        mul_out <= stage2_reg;
    end
end

endmodule