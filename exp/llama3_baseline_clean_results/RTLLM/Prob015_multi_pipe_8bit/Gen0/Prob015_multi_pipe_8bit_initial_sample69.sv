module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Internal signals
reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
wire [15:0] temp;
reg [15:0] sum [7:1];
reg [15:0] mul_out_reg;

// Input control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {7'd0, 1'b1};
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0};
    end
end

// Output enable signal
assign mul_en_out = mul_en_out_reg[7];

// Input registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial product generation
assign temp = (mul_b_reg[0] ? mul_a_reg : 8'd0) |
              ({1'b0, mul_b_reg[1] ? mul_a_reg : 8'd0}) |
              ({2'b00, mul_b_reg[2] ? mul_a_reg : 8'd0}) |
              ({3'b000, mul_b_reg[3] ? mul_a_reg : 8'd0}) |
              ({4'b0000, mul_b_reg[4] ? mul_a_reg : 8'd0}) |
              ({5'b00000, mul_b_reg[5] ? mul_a_reg : 8'd0}) |
              ({6'b000000, mul_b_reg[6] ? mul_a_reg : 8'd0}) |
              ({7'b0000000, mul_b_reg[7] ? mul_a_reg : 8'd0});

// Partial sum calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum[1] <= 16'd0;
        sum[2] <= 16'd0;
        sum[3] <= 16'd0;
        sum[4] <= 16'd0;
        sum[5] <= 16'd0;
        sum[6] <= 16'd0;
        sum[7] <= 16'd0;
    end else begin
        sum[1] <= temp;
        sum[2] <= sum[1] + (mul_b_reg[1] ? {8'd0, mul_a_reg} : 16'd0);
        sum[3] <= sum[2] + (mul_b_reg[2] ? {16'd0, mul_a_reg} : 16'd0);
        sum[4] <= sum[3] + (mul_b_reg[3] ? {24'd0, mul_a_reg} : 16'd0);
        sum[5] <= sum[4] + (mul_b_reg[4] ? {32'd0, mul_a_reg} : 16'd0);
        sum[6] <= sum[5] + (mul_b_reg[5] ? {40'd0, mul_a_reg} : 16'd0);
        sum[7] <= sum[6] + (mul_b_reg[6] ? {48'd0, mul_a_reg} : 16'd0);
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'd0;
    end else begin
        mul_out_reg <= sum[7] + (mul_b_reg[7] ? {56'd0, mul_a_reg} : 16'd0);
    end
end

// Output assignment
assign mul_out = (mul_en_out) ? mul_out_reg : 16'd0;

endmodule