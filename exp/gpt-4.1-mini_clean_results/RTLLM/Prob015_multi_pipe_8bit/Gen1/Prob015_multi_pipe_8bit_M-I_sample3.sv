module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

// Pipeline enable signal registers: 3-stage pipeline
reg [2:0] mul_en_out_reg;

// Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 3'b0;
        mul_a_reg      <= 8'd0;
        mul_b_reg      <= 8'd0;
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[1:0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

assign mul_en_out = mul_en_out_reg[2];

// Partial product generation - combinational wires using shifts
wire [15:0] temp0 = mul_b_reg[0] ? ( {8'd0, mul_a_reg}         << 0) : 16'd0;
wire [15:0] temp1 = mul_b_reg[1] ? ( {8'd0, mul_a_reg}         << 1) : 16'd0;
wire [15:0] temp2 = mul_b_reg[2] ? ( {8'd0, mul_a_reg}         << 2) : 16'd0;
wire [15:0] temp3 = mul_b_reg[3] ? ( {8'd0, mul_a_reg}         << 3) : 16'd0;
wire [15:0] temp4 = mul_b_reg[4] ? ( {8'd0, mul_a_reg}         << 4) : 16'd0;
wire [15:0] temp5 = mul_b_reg[5] ? ( {8'd0, mul_a_reg}         << 5) : 16'd0;
wire [15:0] temp6 = mul_b_reg[6] ? ( {8'd0, mul_a_reg}         << 6) : 16'd0;
wire [15:0] temp7 = mul_b_reg[7] ? ( {8'd0, mul_a_reg}         << 7) : 16'd0;

// Stage 2 registers - sum partial products in pairs
reg [15:0] sum0, sum1, sum2, sum3;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0 <= 16'd0;
        sum1 <= 16'd0;
        sum2 <= 16'd0;
        sum3 <= 16'd0;
    end else begin
        if (mul_en_out_reg[1]) begin
            sum0 <= temp0 + temp1;
            sum1 <= temp2 + temp3;
            sum2 <= temp4 + temp5;
            sum3 <= temp6 + temp7;
        end else begin
            sum0 <= 16'd0;
            sum1 <= 16'd0;
            sum2 <= 16'd0;
            sum3 <= 16'd0;
        end
    end
end

// Stage 3 register - final sum accumulation
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
    end else begin
        if (mul_en_out_reg[2]) begin
            mul_out_reg <= sum0 + sum1 + sum2 + sum3;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end
end

// Output muxing based on enable
assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule