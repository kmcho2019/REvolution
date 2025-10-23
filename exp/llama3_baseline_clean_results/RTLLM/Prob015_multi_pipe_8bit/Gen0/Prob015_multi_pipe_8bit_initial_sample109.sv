module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Input control register
reg mul_en_out_reg;

// Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial product wires
wire [15:0] temp [7:0];

// Partial sum registers
reg [15:0] sum [7:0];

// Final product register
reg [15:0] mul_out_reg;

// Output enable signal
assign mul_en_out = mul_en_out_reg;

// Input control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

// Input registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
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
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign temp[i] = (mul_b_reg[i] == 1'b1) ? {8'b0, mul_a_reg} << i : 16'b0;
    end
endgenerate

// Partial sum calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 16'b0;
        end
    end else begin
        sum[0] <= temp[0];
        for (int i = 1; i < 8; i++) begin
            sum[i] <= sum[i-1] + temp[i];
        end
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= sum[7];
    end
end

// Output assignment
assign mul_out = (mul_en_out_reg == 1'b1) ? mul_out_reg : 16'b0;

endmodule