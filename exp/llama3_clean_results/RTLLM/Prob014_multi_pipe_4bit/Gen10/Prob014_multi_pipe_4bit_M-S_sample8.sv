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

// declare the registers for the intermediate sum values
reg [data_width-1:0] sum_reg1;
reg [data_width-1:0] sum_reg2;

// update the intermediate sum values and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset the intermediate sum values and output
        sum_reg1 <= 8'd0;
        sum_reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // update the intermediate sum values
        if (sum_reg1 == 8'd0) begin
            sum_reg1 <= (mul_b[0] == 1'b1) ? {4'b0, mul_a} : 8'd0;
        end else if (sum_reg2 == 8'd0) begin
            sum_reg2 <= sum_reg1;
            sum_reg1 <= (mul_b[1] == 1'b1) ? ({4'b0, mul_a} << 1) : 8'd0;
        end else begin
            sum_reg2 <= sum_reg2 + sum_reg1;
            sum_reg1 <= (mul_b[2] == 1'b1) ? ({4'b0, mul_a} << 2) : 8'd0;
        end
        // update the output
        if (sum_reg2 != 8'd0 && sum_reg1 == 8'd0) begin
            mul_out <= sum_reg2 + (mul_b[3] == 1'b1) ? ({4'b0, mul_a} << 3) : 8'd0;
        end
    end
end

endmodule