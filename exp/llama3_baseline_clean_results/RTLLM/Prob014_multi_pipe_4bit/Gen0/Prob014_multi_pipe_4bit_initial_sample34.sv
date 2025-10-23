module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Define parameter for input signal width
parameter size = 4;

// Intermediate registers to store partial sum values
reg [7:0] reg1;
reg [7:0] reg2;

// Extended input signals
wire [7:0] mul_a_ext = {4'b0000, mul_a};

// Generate block to perform multiplication for each bit position of the multiplier (mul_b)
wire [7:0] partial_products [3:0];
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        assign partial_products[i] = (mul_b[i] == 1'b1) ? (mul_a_ext << i) : 8'b0;
    end
endgenerate

// Add of partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 8'b0;
    end else begin
        reg1 <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= 8'b0;
    end else begin
        reg2 <= reg1;
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= reg2;
    end
end

endmodule