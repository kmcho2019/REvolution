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
reg [7:0] stage1_reg [size:0];
reg [7:0] stage2_reg [size:0];

// generate the partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        // calculate the partial product for each bit position
        assign stage1_reg[i] = (mul_b[i] == 1'b1)? ({4'b0, mul_a} << i) : 8'd0;
    end
endgenerate

// update the registers and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset the registers and output
        for (int i = 0; i <= size; i++) begin
            stage1_reg[i] <= 8'd0;
            stage2_reg[i] <= 8'd0;
        end
        mul_out <= 8'd0;
    end else begin
        // update the stage1 registers
        for (int i = 0; i < size; i++) begin
            stage2_reg[i] <= stage1_reg[i];
        end
        stage2_reg[size] <= 8'd0;
        
        // update the stage2 registers
        for (int i = 0; i < size; i++) begin
            if (i == 0) begin
                stage1_reg[i] <= stage2_reg[i];
            end else begin
                stage1_reg[i] <= stage1_reg[i-1] + stage2_reg[i];
            end
        end
        
        // update the output
        mul_out <= stage1_reg[size-1];
    end
end

endmodule