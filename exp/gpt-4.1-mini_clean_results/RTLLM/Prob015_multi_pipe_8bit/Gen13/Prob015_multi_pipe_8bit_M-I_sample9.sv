module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 1: Register inputs and enable
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_stage1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg      <= 8'd0;
        mul_b_reg      <= 8'd0;
        mul_en_stage1  <= 1'b0;
    end else begin
        mul_en_stage1 <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Stage 2: Generate partial products and sum in two groups
wire [15:0] pp[7:0];

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_pp
        assign pp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Partial sums stage 2: sum pp[0..3] and pp[4..7]
reg [15:0] sum_low;
reg [15:0] sum_high;
reg        mul_en_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_low       <= 16'd0;
        sum_high      <= 16'd0;
        mul_en_stage2 <= 1'b0;
    end else begin
        if (mul_en_stage1) begin
            sum_low  <= pp[0] + pp[1] + pp[2] + pp[3];
            sum_high <= pp[4] + pp[5] + pp[6] + pp[7];
        end else begin
            sum_low  <= 16'd0;
            sum_high <= 16'd0;
        end
        mul_en_stage2 <= mul_en_stage1;
    end
end

// Stage 3: Final sum and register output enable
reg [15:0] mul_out_reg;
reg        mul_en_stage3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg   <= 16'd0;
        mul_en_stage3 <= 1'b0;
    end else begin
        if (mul_en_stage2) begin
            mul_out_reg <= sum_low + sum_high;
        end else begin
            mul_out_reg <= 16'd0;
        end
        mul_en_stage3 <= mul_en_stage2;
    end
end

// Output assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out    <= 16'd0;
    end else begin
        mul_en_out <= mul_en_stage3;
        mul_out    <= mul_en_stage3 ? mul_out_reg : 16'd0;
    end
end

endmodule