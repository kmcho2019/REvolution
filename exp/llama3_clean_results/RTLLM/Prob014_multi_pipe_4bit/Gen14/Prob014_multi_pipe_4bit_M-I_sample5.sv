module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// define the number of pipeline stages
parameter num_stages = 2;

// define the width of the data path
parameter data_width = 8;

// declare the registers for the multiplicand and multiplier
reg [size-1:0] multiplicand_reg;
reg [size-1:0] multiplier_reg;

// declare the pipeline register for intermediate results
reg [data_width-1:0] pipeline_reg1;
reg [data_width-1:0] pipeline_reg2;

// sequential logic
always @(posedge clk or negedge rst_n) begin
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

        // calculate the partial products and store in pipeline registers
        if (multiplier_reg[0] == 1'b1) begin
            pipeline_reg1 <= {4'b0, multiplicand_reg};
        end else begin
            pipeline_reg1 <= 8'd0;
        end

        if (multiplier_reg[1] == 1'b1) begin
            pipeline_reg2 <= ({4'b0, multiplicand_reg} << 1);
        end else begin
            pipeline_reg2 <= 8'd0;
        end

        // add the partial products and store in output register
        if (clk) begin
            mul_out <= pipeline_reg1 + pipeline_reg2 + ((multiplier_reg[2] == 1'b1) ? ({4'b0, multiplicand_reg} << 2) : 8'd0) + ((multiplier_reg[3] == 1'b1) ? ({4'b0, multiplicand_reg} << 3) : 8'd0);
        end
    end
end

endmodule