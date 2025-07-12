module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Input control
reg [0:0] mul_en_out_reg;

// Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial product generation
wire [15:0] temp;

// Partial sum calculation
reg [15:0] sum;

// Final product calculation
reg [15:0] mul_out_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        sum <= 16'd0;
        mul_out_reg <= 16'd0;
    end else begin
        mul_en_out_reg <= mul_en_in;
        
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        
        // Partial product generation
        temp[0]  = (mul_b[0] == 1'b1)? {8'd0, mul_a_reg} : 16'd0;
        temp[1]  = (mul_b[1] == 1'b1)? {8'd0, mul_a_reg} : 16'd0;
        temp[2]  = (mul_b[2] == 1'b1)? {8'd0, mul_a_reg} : 16'd0;
        temp[3]  = (mul_b[3] == 1'b1)? {8'd0, mul_a_reg} : 16'd0;
        temp[4]  = (mul_b[4] == 1'b1)? {8'd0, mul_a_reg} : 16'd0;
        temp[5]  = (mul_b[5] == 1'b1)? {8'd0, mul_a_reg} : 16'd0;
        temp[6]  = (mul_b[6] == 1'b1)? {8'd0, mul_a_reg} : 16'd0;
        temp[7]  = (mul_b[7] == 1'b1)? {8'd0, mul_a_reg} : 16'd0;
        
        temp[8]  = (mul_b[0] == 1'b1)? {1'd0, mul_a_reg, 7'd0} : 16'd0;
        temp[9]  = (mul_b[1] == 1'b1)? {1'd0, mul_a_reg, 7'd0} : 16'd0;
        temp[10] = (mul_b[2] == 1'b1)? {1'd0, mul_a_reg, 7'd0} : 16'd0;
        temp[11] = (mul_b[3] == 1'b1)? {1'd0, mul_a_reg, 7'd0} : 16'd0;
        temp[12] = (mul_b[4] == 1'b1)? {1'd0, mul_a_reg, 7'd0} : 16'd0;
        temp[13] = (mul_b[5] == 1'b1)? {1'd0, mul_a_reg, 7'd0} : 16'd0;
        temp[14] = (mul_b[6] == 1'b1)? {1'd0, mul_a_reg, 7'd0} : 16'd0;
        temp[15] = (mul_b[7] == 1'b1)? {1'd0, mul_a_reg, 7'd0} : 16'd0;
        
        // Partial sum calculation
        sum <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7] + 
               temp[8] + temp[9] + temp[10] + temp[11] + temp[12] + temp[13] + temp[14] + temp[15];
        
        // Final product calculation
        mul_out_reg <= sum;
    end
end

assign mul_en_out = mul_en_out_reg[0];

assign mul_out = (mul_en_out)? mul_out_reg : 16'd0;

endmodule