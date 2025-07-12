module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;

wire [15:0] temp;

// Input control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= mul_en_out_reg;
    end
end

// Input registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial product generation
assign temp = {16{(mul_b_reg[7]? mul_a_reg : 8'b0) << 7}} | 
              {16{(mul_b_reg[6]? mul_a_reg : 8'b0) << 6}} | 
              {16{(mul_b_reg[5]? mul_a_reg : 8'b0) << 5}} | 
              {16{(mul_b_reg[4]? mul_a_reg : 8'b0) << 4}} | 
              {16{(mul_b_reg[3]? mul_a_reg : 8'b0) << 3}} | 
              {16{(mul_b_reg[2]? mul_a_reg : 8'b0) << 2}} | 
              {16{(mul_b_reg[1]? mul_a_reg : 8'b0) << 1}} | 
              {16{(mul_b_reg[0]? mul_a_reg : 8'b0) << 0}};

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_out_reg <= temp;
    end else begin
        mul_out_reg <= mul_out_reg;
    end
end

// Output assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg)? mul_out_reg : 16'b0;

endmodule