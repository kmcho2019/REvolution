module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 1 registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_reg;

// Stage 1: Generate partial products
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
        assign partial_products[i] = mul_en_reg && mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Stage 2 registers - sum pairs of partial products
reg [15:0] sum_stage2 [3:0];
reg        mul_en_stage2;

// Stage 3 registers - sum pairs from stage 2
reg [15:0] sum_stage3 [1:0];
reg        mul_en_stage3;

// Stage 4 registers - final sum and output enable
reg [15:0] product_reg;
reg        mul_en_stage4;

// Pipeline registers for enable signal
reg [3:0] mul_en_pipe;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers and outputs
        mul_a_reg       <= 8'd0;
        mul_b_reg       <= 8'd0;
        mul_en_reg      <= 1'b0;
        sum_stage2[0]   <= 16'd0;
        sum_stage2[1]   <= 16'd0;
        sum_stage2[2]   <= 16'd0;
        sum_stage2[3]   <= 16'd0;
        mul_en_stage2   <= 1'b0;
        sum_stage3[0]   <= 16'd0;
        sum_stage3[1]   <= 16'd0;
        mul_en_stage3   <= 1'b0;
        product_reg     <= 16'd0;
        mul_en_stage4   <= 1'b0;
        mul_en_pipe     <= 4'd0;
        mul_en_out      <= 1'b0;
        mul_out         <= 16'd0;
    end else begin
        // Stage 1: Capture inputs and input enable
        mul_en_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Stage 2: sum partial products in pairs
        sum_stage2[0] <= partial_products[0] + partial_products[1]; // sum of pp0 and pp1
        sum_stage2[1] <= partial_products[2] + partial_products[3]; // sum of pp2 and pp3
        sum_stage2[2] <= partial_products[4] + partial_products[5]; // sum of pp4 and pp5
        sum_stage2[3] <= partial_products[6] + partial_products[7]; // sum of pp6 and pp7
        mul_en_stage2 <= mul_en_reg;

        // Stage 3: sum pairs from stage 2
        sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
        sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        mul_en_stage3 <= mul_en_stage2;

        // Stage 4: final sum
        product_reg   <= sum_stage3[0] + sum_stage3[1];
        mul_en_stage4 <= mul_en_stage3;

        // Output enable pipelining for synchronization with product
        mul_en_pipe   <= {mul_en_pipe[2:0], mul_en_in};
        mul_en_out    <= mul_en_stage4;

        // Output product if enabled; else zero
        mul_out       <= mul_en_stage4 ? product_reg : 16'd0;
    end
end

endmodule