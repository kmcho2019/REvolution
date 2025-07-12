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

// declare the register for the pipeline stage
reg [data_width-1:0] stage_reg;

// declare the wires for the partial products
wire [data_width-1:0] partial_product [size-1:0];

// generate the partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_product[i] = (mul_b[i] == 1'b1) ? ({4'b0, mul_a} << i) : {data_width{1'b0}};
    end
endgenerate

// calculate the sum of the partial products
wire [data_width-1:0] sum;
assign sum = partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];

// update the pipeline stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_reg <= 8'd0;
    end else begin
        stage_reg <= sum;
    end
end

// assign the output
assign mul_out = stage_reg;

endmodule