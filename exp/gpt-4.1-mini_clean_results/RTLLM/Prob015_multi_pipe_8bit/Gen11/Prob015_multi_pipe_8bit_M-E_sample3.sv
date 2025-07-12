module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 1 registers: input capture and partial product generation
reg         mul_en_s1;
reg [7:0]   mul_a_s1;
reg [7:0]   mul_b_s1;
wire [15:0] pp [7:0]; // partial products

// Generate partial products in combinational logic from registered inputs
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign pp[i] = mul_b_s1[i] ? (mul_a_s1 << i) : 16'd0;
    end
endgenerate

// Stage 2 registers: pairwise sum of partial products (8->4)
reg         mul_en_s2;
reg [15:0]  sum_s2 [3:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_s1 <= 1'b0;
        mul_a_s1 <= 8'd0;
        mul_b_s1 <= 8'd0;
    end else begin
        mul_en_s1 <= mul_en_in;
        if (mul_en_in) begin
            mul_a_s1 <= mul_a;
            mul_b_s1 <= mul_b;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_s2 <= 1'b0;
        sum_s2[0] <= 16'd0;
        sum_s2[1] <= 16'd0;
        sum_s2[2] <= 16'd0;
        sum_s2[3] <= 16'd0;
    end else begin
        mul_en_s2 <= mul_en_s1;
        if (mul_en_s1) begin
            sum_s2[0] <= pp[0] + pp[1];
            sum_s2[1] <= pp[2] + pp[3];
            sum_s2[2] <= pp[4] + pp[5];
            sum_s2[3] <= pp[6] + pp[7];
        end else begin
            sum_s2[0] <= 16'd0;
            sum_s2[1] <= 16'd0;
            sum_s2[2] <= 16'd0;
            sum_s2[3] <= 16'd0;
        end
    end
end

// Stage 3 registers: sum stage (4->2)
reg         mul_en_s3;
reg [15:0]  sum_s3 [1:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_s3 <= 1'b0;
        sum_s3[0] <= 16'd0;
        sum_s3[1] <= 16'd0;
    end else begin
        mul_en_s3 <= mul_en_s2;
        if (mul_en_s2) begin
            sum_s3[0] <= sum_s2[0] + sum_s2[1];
            sum_s3[1] <= sum_s2[2] + sum_s2[3];
        end else begin
            sum_s3[0] <= 16'd0;
            sum_s3[1] <= 16'd0;
        end
    end
end

// Stage 4 registers: final sum and output enable
reg         mul_en_s4;
reg [15:0]  mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_s4   <= 1'b0;
        mul_out_reg <= 16'd0;
    end else begin
        mul_en_s4 <= mul_en_s3;
        if (mul_en_s3) begin
            mul_out_reg <= sum_s3[0] + sum_s3[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'd0;
    end else begin
        mul_en_out <= mul_en_s4;
        mul_out <= mul_en_s4 ? mul_out_reg : 16'd0;
    end
end

endmodule