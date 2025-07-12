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
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end
assign mul_en_out = mul_en_out_reg[0];

// Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
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
wire [7:0] temp [7:0];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        assign temp[i] = (mul_b_reg[i] == 1'b1) ? mul_a_reg : 8'b0;
    end
endgenerate

// Partial sum calculation
reg [15:0] sum [7:0];
integer j;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (j = 0; j < 8; j = j + 1) begin
            sum[j] <= 16'b0;
        end
    end else if (mul_en_in) begin
        sum[0] <= {8'b0, temp[0]};
        for (j = 1; j < 8; j = j + 1) begin
            sum[j] <= sum[j - 1] + {8'b0, temp[j]} << j;
        end
    end else begin
        for (j = 0; j < 8; j = j + 1) begin
            sum[j] <= sum[j];
        end
    end
end

// Final product calculation
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_out_reg <= sum[7];
    end else begin
        mul_out_reg <= mul_out_reg;
    end
end

// Output assignment
assign mul_out = (mul_en_out) ? mul_out_reg : 16'b0;

endmodule