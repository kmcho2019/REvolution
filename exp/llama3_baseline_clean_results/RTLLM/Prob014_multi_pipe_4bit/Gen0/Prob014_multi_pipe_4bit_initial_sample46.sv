module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Extend the input signals by adding 4 number of zero bits at the most significant bit positions
reg [7:0] a_extended;
reg [7:0] b_extended;
reg [7:0] partial_product [3:0];
reg [7:0] sum_register_1;
reg [7:0] sum_register_2;

// Extend the input signals
assign a_extended = {4'd0, mul_a};
assign b_extended = {4'd0, mul_b};

// Generate block to perform multiplication for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                partial_product[i] <= 8'd0;
            end else if (b_extended[i] == 1'b1) begin
                partial_product[i] <= a_extended << i;
            end else begin
                partial_product[i] <= 8'd0;
            end
        end
    end
endgenerate

// Register to store the intermediate sum values
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_register_1 <= 8'd0;
    end else begin
        sum_register_1 <= partial_product[0] + partial_product[1];
    end
end

// Register to store the intermediate sum values
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_register_2 <= 8'd0;
    end else begin
        sum_register_2 <= sum_register_1 + partial_product[2] + partial_product[3];
    end
end

// Calculate the final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum_register_2;
    end
end

endmodule