module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

    // Define the size of the input signals
    parameter size = 4;

    // Extend the input signals by adding 'size' number of zero bits at the most significant bit positions
    wire [7:0] mul_a_ext = {4'd0, mul_a};
    wire [7:0] mul_b_ext = {4'd0, mul_b};

    // Declare the registers to store intermediate values
    reg [7:0] reg1;
    reg [7:0] reg2;

    // Declare the product output
    reg [7:0] mul_out_reg;

    // Generate block to perform multiplication for each bit position of the multiplier
    wire [7:0] partial_product [3:0];
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            assign partial_product[i] = (mul_b_ext[i] == 1'b1) ? (mul_a_ext << i) : 8'd0;
        end
    endgenerate

    // Add operation to calculate the intermediate sum values
    wire [7:0] sum1;
    assign sum1 = partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];

    // Add operation to calculate the final product
    wire [7:0] sum2;
    assign sum2 = reg1 + reg2;

    // Update the registers on the positive edge of the clock signal or the falling edge of the reset signal
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg1 <= 8'd0;
            reg2 <= 8'd0;
            mul_out_reg <= 8'd0;
        end else begin
            reg1 <= sum1;
            reg2 <= reg1;
            mul_out_reg <= sum2;
        end
    end

    // Assign the product output
    assign mul_out = mul_out_reg;

endmodule