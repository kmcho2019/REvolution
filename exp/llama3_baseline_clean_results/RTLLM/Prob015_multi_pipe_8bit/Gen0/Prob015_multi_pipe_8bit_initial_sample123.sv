module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [0:0] mul_en_out_reg;
wire [15:0] temp;
reg [15:0] sum;
reg [15:0] mul_out_reg;

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

assign mul_en_out = mul_en_out_reg;

// Input Registers
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

// Partial Product Generation
always @(*) begin
    temp = 16'b0;
    if (mul_b_reg[0]) temp = {8'b0, mul_a_reg};
    if (mul_b_reg[1]) temp = temp + {7'b0, mul_a_reg, 1'b0};
    if (mul_b_reg[2]) temp = temp + {6'b0, mul_a_reg, 2'b00};
    if (mul_b_reg[3]) temp = temp + {5'b0, mul_a_reg, 3'b000};
    if (mul_b_reg[4]) temp = temp + {4'b0, mul_a_reg, 4'b0000};
    if (mul_b_reg[5]) temp = temp + {3'b0, mul_a_reg, 5'b00000};
    if (mul_b_reg[6]) temp = temp + {2'b0, mul_a_reg, 6'b000000};
    if (mul_b_reg[7]) temp = temp + {1'b0, mul_a_reg, 7'b0000000};
end

// Partial Sum Calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 16'b0;
    end else if (mul_en_in) begin
        sum <= temp;
    end else begin
        sum <= sum;
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_out_reg <= sum;
    end else begin
        mul_out_reg <= mul_out_reg;
    end
end

// Output Assignment
assign mul_out = (mul_en_out) ? mul_out_reg : 16'b0;

endmodule