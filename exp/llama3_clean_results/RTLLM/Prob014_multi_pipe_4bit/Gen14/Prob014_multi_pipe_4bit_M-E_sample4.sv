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

// declare the registers for the intermediate results
reg [data_width-1:0] partial_product_reg;
reg [data_width-1:0] accumulated_product_reg;

// generate partial products
reg [data_width-1:0] partial_product;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset the registers
        multiplicand_reg <= 4'd0;
        multiplier_reg <= 4'd0;
        partial_product_reg <= 8'd0;
        accumulated_product_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // load the multiplicand and multiplier
        multiplicand_reg <= mul_a;
        multiplier_reg <= mul_b;

        // generate partial products
        for (int i = 0; i < size; i++) begin
            if (multiplier_reg[i] == 1'b1) begin
                partial_product = {4'b0, multiplicand_reg} << i;
            end else begin
                partial_product = 8'd0;
            end

            // accumulate partial products
            if (i == 0) begin
                partial_product_reg <= partial_product;
            end else begin
                partial_product_reg <= partial_product_reg + partial_product;
            end
        end

        // store the accumulated product
        accumulated_product_reg <= partial_product_reg;
    end
end

// output the final product
always @(posedge clk) begin
    mul_out <= accumulated_product_reg;
end

endmodule