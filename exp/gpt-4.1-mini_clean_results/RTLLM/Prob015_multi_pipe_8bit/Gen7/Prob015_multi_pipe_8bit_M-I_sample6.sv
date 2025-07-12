module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 0: Input registers and enable pipeline
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_stage0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg      <= 8'd0;
        mul_b_reg      <= 8'd0;
        mul_en_stage0  <= 1'b0;
    end else begin
        mul_en_stage0 <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Stage 1: Generate and register partial products (16-bit)
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_pp
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

reg [15:0] pp_reg [7:0];
reg        mul_en_stage1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp_reg[0] <= 16'd0; pp_reg[1] <= 16'd0; pp_reg[2] <= 16'd0; pp_reg[3] <= 16'd0;
        pp_reg[4] <= 16'd0; pp_reg[5] <= 16'd0; pp_reg[6] <= 16'd0; pp_reg[7] <= 16'd0;
        mul_en_stage1 <= 1'b0;
    end else begin
        if (mul_en_stage0) begin
            pp_reg[0] <= partial_products[0];
            pp_reg[1] <= partial_products[1];
            pp_reg[2] <= partial_products[2];
            pp_reg[3] <= partial_products[3];
            pp_reg[4] <= partial_products[4];
            pp_reg[5] <= partial_products[5];
            pp_reg[6] <= partial_products[6];
            pp_reg[7] <= partial_products[7];
        end else begin
            pp_reg[0] <= 16'd0; pp_reg[1] <= 16'd0; pp_reg[2] <= 16'd0; pp_reg[3] <= 16'd0;
            pp_reg[4] <= 16'd0; pp_reg[5] <= 16'd0; pp_reg[6] <= 16'd0; pp_reg[7] <= 16'd0;
        end
        mul_en_stage1 <= mul_en_stage0;
    end
end

// Stage 2: First level addition: sum pairs of partial products
reg [15:0] sum_stage2 [3:0];
reg        mul_en_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2[0] <= 16'd0;
        sum_stage2[1] <= 16'd0;
        sum_stage2[2] <= 16'd0;
        sum_stage2[3] <= 16'd0;
        mul_en_stage2 <= 1'b0;
    end else begin
        if (mul_en_stage1) begin
            sum_stage2[0] <= pp_reg[0] + pp_reg[1];
            sum_stage2[1] <= pp_reg[2] + pp_reg[3];
            sum_stage2[2] <= pp_reg[4] + pp_reg[5];
            sum_stage2[3] <= pp_reg[6] + pp_reg[7];
        end else begin
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
            sum_stage2[2] <= 16'd0;
            sum_stage2[3] <= 16'd0;
        end
        mul_en_stage2 <= mul_en_stage1;
    end
end

// Stage 3: Second level addition: sum pairs of sum_stage2 results
reg [15:0] sum_stage3 [1:0];
reg        mul_en_stage3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3[0] <= 16'd0;
        sum_stage3[1] <= 16'd0;
        mul_en_stage3 <= 1'b0;
    end else begin
        if (mul_en_stage2) begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end else begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end
        mul_en_stage3 <= mul_en_stage2;
    end
end

// Stage 4: Final addition and output register
reg [15:0] mul_out_reg;
reg        mul_en_stage4;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg   <= 16'd0;
        mul_en_stage4 <= 1'b0;
    end else begin
        if (mul_en_stage3) begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
        mul_en_stage4 <= mul_en_stage3;
    end
end

// Output assignment: mux output with enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out    <= 16'd0;
    end else begin
        mul_en_out <= mul_en_stage4;
        mul_out    <= mul_en_stage4 ? mul_out_reg : 16'd0;
    end
end

endmodule