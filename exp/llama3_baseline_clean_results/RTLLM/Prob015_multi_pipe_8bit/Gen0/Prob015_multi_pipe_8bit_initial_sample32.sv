module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Input control
reg [7:0] mul_en_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {1'b1, 7'b0};
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0};
    end
end

assign mul_en_out = mul_en_out_reg[7];

// Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial product generation
wire [7:0] temp [7:1];
genvar i;
generate
    for (i = 1; i <= 7; i++) begin
        assign temp[i] = (mul_b_reg[i-1] == 1'b1) ? mul_a_reg : 8'b0;
    end
endgenerate

// Partial sum calculation
reg [15:0] sum [7:1];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 1; i <= 7; i++) begin
            sum[i] <= 16'b0;
        end
    end else begin
        sum[1] <= {8'b0, temp[1]};
        for (i = 2; i <= 7; i++) begin
            sum[i] <= sum[i-1] + {8'b0, temp[i]};
        end
    end
end

// Final product calculation
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_out_reg <= sum[7];
    end
end

// Output assignment
always @(posedge clk) begin
    if (mul_en_out) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'b0;
    end
end

endmodule