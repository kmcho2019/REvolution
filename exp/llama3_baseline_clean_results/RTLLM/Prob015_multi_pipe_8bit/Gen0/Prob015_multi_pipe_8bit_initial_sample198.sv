module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_out_reg;

// Wires for partial products
wire [15:0] temp;

// Registers for partial sums
reg [15:0] sum;

// Final product register
reg [15:0] mul_out_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset logic
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_en_out_reg <= 1'b0;
        sum <= 16'd0;
        mul_out_reg <= 16'd0;
    end else if (mul_en_in) begin
        // Store input values in registers
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= mul_en_in;
        
        // Initialize sum to 0
        sum <= 16'd0;
        
        // Generate partial products and calculate partial sums
        temp[0]  <= (mul_b[0] == 1'b1)? {8'd0, mul_a_reg} : 16'd0;
        temp[1]  <= (mul_b[1] == 1'b1)? {7'd0, mul_a_reg, 1'b0} : 16'd0;
        temp[2]  <= (mul_b[2] == 1'b1)? {6'd0, mul_a_reg, 2'b00} : 16'd0;
        temp[3]  <= (mul_b[3] == 1'b1)? {5'd0, mul_a_reg, 3'b000} : 16'd0;
        temp[4]  <= (mul_b[4] == 1'b1)? {4'd0, mul_a_reg, 4'b0000} : 16'd0;
        temp[5]  <= (mul_b[5] == 1'b1)? {3'd0, mul_a_reg, 5'b00000} : 16'd0;
        temp[6]  <= (mul_b[6] == 1'b1)? {2'd0, mul_a_reg, 6'b000000} : 16'd0;
        temp[7]  <= (mul_b[7] == 1'b1)? {1'd0, mul_a_reg, 7'b0000000} : 16'd0;
        
        sum <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
        
        // Update final product
        mul_out_reg <= sum;
    end else begin
        // If input enable is low, do not update registers
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
        mul_en_out_reg <= mul_en_out_reg;
        sum <= sum;
        mul_out_reg <= mul_out_reg;
    end
end

// Output enable signal assignment
assign mul_en_out = mul_en_out_reg;

// Output product assignment
always @ (*) begin
    if (mul_en_out_reg) begin
        mul_out = mul_out_reg;
    end else begin
        mul_out = 16'd0;
    end
end

endmodule