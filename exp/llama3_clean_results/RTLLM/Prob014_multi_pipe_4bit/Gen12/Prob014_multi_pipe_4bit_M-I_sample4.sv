module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output [7:0] mul_out  // product output signal
);

// define the size of the multiplier and multiplicand
parameter size = 4;

// define the width of the data path
parameter data_width = 8;

// declare the registers for the pipeline stages
reg [data_width-1:0] stage1_reg;
reg [data_width-1:0] stage2_reg;

// declare the wires for the partial products
wire [data_width-1:0] partial_product [size-1:0];

// generate the partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_product[i] = (mul_b[i] == 1'b1)? ({4'b0, mul_a} << i) : 8'd0;
    end
endgenerate

// calculate the sum of the partial products using a Wallace tree
wire [data_width-1:0] sum;
wire [data_width-1:0] sum1, sum2;
assign sum1 = partial_product[0] + partial_product[1];
assign sum2 = partial_product[2] + partial_product[3];
assign sum = sum1 + sum2;

// update the pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
    end else begin
        stage1_reg <= sum;
        stage2_reg <= stage1_reg;
    end
end

// assign the output
assign mul_out = stage2_reg;

endmodule