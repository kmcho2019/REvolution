module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// define the width of the data path
parameter data_width = 8;

// declare the registers for the multiplicand and multiplier
reg [size-1:0] multiplicand_reg;
reg [size-1:0] multiplier_reg;

// declare the pipeline registers for intermediate results
reg [data_width-1:0] pipeline_reg1;
reg [data_width-1:0] pipeline_reg2;

// sequential logic
always @(posedge clk) begin
    if (!rst_n) begin
        // reset the registers
        multiplicand_reg <= 4'd0;
        multiplier_reg <= 4'd0;
        pipeline_reg1 <= 8'd0;
        pipeline_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // load the multiplicand and multiplier
        multiplicand_reg <= mul_a;
        multiplier_reg <= mul_b;

        // calculate the partial products and store in pipeline register 1
        if (multiplier_reg[0] == 1'b1) begin
            pipeline_reg1 <= {4'b0, multiplicand_reg};
        end else begin
            pipeline_reg1 <= 8'd0;
        end

        // shift and add the partial products and store in pipeline register 2
        if (multiplier_reg[1] == 1'b1) begin
            pipeline_reg2 <= pipeline_reg1 + ({4'b0, multiplicand_reg} << 1);
        end else begin
            pipeline_reg2 <= pipeline_reg1;
        end

        // add the remaining partial products and store in output register
        if (multiplier_reg[2] == 1'b1) begin
            mul_out <= pipeline_reg2 + ({4'b0, multiplicand_reg} << 2);
        end else if (multiplier_reg[3] == 1'b1) begin
            mul_out <= pipeline_reg2 + ({4'b0, multiplicand_reg} << 3);
        end else begin
            mul_out <= pipeline_reg2;
        end
    end
end

endmodule