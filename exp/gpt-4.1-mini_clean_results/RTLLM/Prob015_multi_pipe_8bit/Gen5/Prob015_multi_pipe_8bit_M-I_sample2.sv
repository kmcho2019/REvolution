module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 0 registers: input capture
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg   <= 8'd0;
        mul_b_reg   <= 8'd0;
        mul_en_reg  <= 1'b0;
    end else begin
        mul_en_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Stage 0: partial product generation (wires)
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_pp
        assign partial_products[i] = (mul_b_reg[i]) ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Stage 1: add pairs of partial products and register sums and enable
reg [15:0] sum01_reg, sum23_reg, sum45_reg, sum67_reg;
reg        en_stage1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum01_reg <= 16'd0;
        sum23_reg <= 16'd0;
        sum45_reg <= 16'd0;
        sum67_reg <= 16'd0;
        en_stage1 <= 1'b0;
    end else begin
        if (mul_en_reg) begin
            sum01_reg <= partial_products[0] + partial_products[1];
            sum23_reg <= partial_products[2] + partial_products[3];
            sum45_reg <= partial_products[4] + partial_products[5];
            sum67_reg <= partial_products[6] + partial_products[7];
        end else begin
            sum01_reg <= 16'd0;
            sum23_reg <= 16'd0;
            sum45_reg <= 16'd0;
            sum67_reg <= 16'd0;
        end
        en_stage1 <= mul_en_reg;
    end
end

// Stage 2: add sums from stage 1 and register sums and enable
reg [15:0] sum0123_reg, sum4567_reg;
reg        en_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0123_reg <= 16'd0;
        sum4567_reg <= 16'd0;
        en_stage2   <= 1'b0;
    end else begin
        if (en_stage1) begin
            sum0123_reg <= sum01_reg + sum23_reg;
            sum4567_reg <= sum45_reg + sum67_reg;
        end else begin
            sum0123_reg <= 16'd0;
            sum4567_reg <= 16'd0;
        end
        en_stage2 <= en_stage1;
    end
end

// Stage 3: final sum and output register
reg [15:0] mul_out_reg;
reg        en_stage3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
        en_stage3   <= 1'b0;
    end else begin
        if (en_stage2) begin
            mul_out_reg <= sum0123_reg + sum4567_reg;
        end else begin
            mul_out_reg <= 16'd0;
        end
        en_stage3 <= en_stage2;
    end
end

// Output enable and product output assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out    <= 16'd0;
    end else begin
        mul_en_out <= en_stage3;
        mul_out    <= en_stage3 ? mul_out_reg : 16'd0;
    end
end

endmodule