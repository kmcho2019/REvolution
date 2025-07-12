module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input control
reg mul_en_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {1'b1, 7'b0};
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0};
    end
end

// Output enable signal
assign mul_en_out = mul_en_out_reg[7];

// Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 0;
        mul_b_reg <= 0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial product generation
wire [15:0] temp [7:0];
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign temp[i] = (mul_b_reg[i] == 1'b1) ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Partial sum calculation
reg [15:0] sum [7:0];
integer j;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (j = 0; j < 8; j++) begin
            sum[j] <= 0;
        end
    end else begin
        sum[0] <= temp[0];
        for (j = 1; j < 8; j++) begin
            sum[j] <= sum[j-1] + temp[j];
        end
    end
end

// Final product calculation
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 0;
    end else begin
        mul_out_reg <= sum[7];
    end
end

// Output assignment
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 0;
    end else if (mul_en_out) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 0;
    end
end

endmodule