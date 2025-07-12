module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// declare the pipeline register for intermediate results
reg [7:0] pipeline_reg1;
reg [7:0] pipeline_reg2;

// sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset the registers
        pipeline_reg1 <= 8'd0;
        pipeline_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // load the multiplicand and multiplier
        pipeline_reg1 <= 8'd0;
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                pipeline_reg1 <= pipeline_reg1 + ({4'b0, mul_a} << i);
            end
        end
        pipeline_reg2 <= pipeline_reg1;
        mul_out <= pipeline_reg2;
    end
end

endmodule