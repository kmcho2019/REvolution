module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline stage 1: input registers and enable
reg        mul_en_s1;
reg [7:0]  mul_a_s1;
reg [7:0]  mul_b_s1;

// Pipeline stage 2: partial products and enable
reg        mul_en_s2;
reg [15:0] pp[7:0]; // partial products registers

// Pipeline stage 3: partial sums registers and enable
reg        mul_en_s3;
reg [15:0] sum_level1_0, sum_level1_1, sum_level1_2, sum_level1_3;
reg [15:0] sum_level2_0, sum_level2_1;
reg [15:0] product_reg;

// Stage 1: Register inputs and enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_s1 <= 1'b0;
        mul_a_s1  <= 8'd0;
        mul_b_s1  <= 8'd0;
    end else begin
        mul_en_s1 <= mul_en_in;
        if(mul_en_in) begin
            mul_a_s1 <= mul_a;
            mul_b_s1 <= mul_b;
        end
    end
end

// Stage 2: Generate partial products from stage 1 inputs
// Each partial product is multiplicand shifted by bit index if multiplier bit set, else zero
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_s2 <= 1'b0;
        for(i=0; i<8; i=i+1) begin
            pp[i] <= 16'd0;
        end
    end else begin
        mul_en_s2 <= mul_en_s1;
        if (mul_en_s1) begin
            for(i=0; i<8; i=i+1) begin
                pp[i] <= mul_b_s1[i] ? ( {8'd0, mul_a_s1} << i ) : 16'd0;
            end
        end else begin
            for(i=0; i<8; i=i+1) begin
                pp[i] <= 16'd0;
            end
        end
    end
end

// Stage 3: Balanced adder tree to sum partial products in 2 clock cycles
// sum_level1 registers hold sums of pairs: (pp0+pp1), (pp2+pp3), (pp4+pp5), (pp6+pp7)
// sum_level2 registers hold sums of two pairs from sum_level1
// product_reg holds final sum of sum_level2 pairs

// Control registers for pipeline stages inside Stage 3
reg        mul_en_stage3_cycle1;
reg        mul_en_stage3_cycle2;
reg        mul_en_stage3_cycle3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all sums and enables
        sum_level1_0 <= 16'd0;
        sum_level1_1 <= 16'd0;
        sum_level1_2 <= 16'd0;
        sum_level1_3 <= 16'd0;
        sum_level2_0 <= 16'd0;
        sum_level2_1 <= 16'd0;
        product_reg  <= 16'd0;
        mul_en_s3    <= 1'b0;
        mul_en_stage3_cycle1 <= 1'b0;
        mul_en_stage3_cycle2 <= 1'b0;
        mul_en_stage3_cycle3 <= 1'b0;
    end else begin
        // Pipeline enable signals through the summation pipeline
        mul_en_stage3_cycle1 <= mul_en_s2;    // enable for first summation stage
        mul_en_stage3_cycle2 <= mul_en_stage3_cycle1; // second stage enable
        mul_en_stage3_cycle3 <= mul_en_stage3_cycle2; // third stage enable
        mul_en_s3 <= mul_en_stage3_cycle3;    // output enable signal delayed to last stage
        
        // Cycle 1: sum pairs of partial products
        if(mul_en_stage3_cycle1) begin
            sum_level1_0 <= pp[0] + pp[1];
            sum_level1_1 <= pp[2] + pp[3];
            sum_level1_2 <= pp[4] + pp[5];
            sum_level1_3 <= pp[6] + pp[7];
        end else begin
            sum_level1_0 <= 16'd0;
            sum_level1_1 <= 16'd0;
            sum_level1_2 <= 16'd0;
            sum_level1_3 <= 16'd0;
        end
        
        // Cycle 2: sum pairs of sums from cycle 1
        if(mul_en_stage3_cycle2) begin
            sum_level2_0 <= sum_level1_0 + sum_level1_1;
            sum_level2_1 <= sum_level1_2 + sum_level1_3;
        end else begin
            sum_level2_0 <= 16'd0;
            sum_level2_1 <= 16'd0;
        end
        
        // Cycle 3: sum final two sums to get product
        if(mul_en_stage3_cycle3) begin
            product_reg <= sum_level2_0 + sum_level2_1;
        end else begin
            product_reg <= 16'd0;
        end
    end
end

// Output assignments with output enable
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'd0;
    end else begin
        mul_en_out <= mul_en_s3;
        mul_out <= mul_en_s3 ? product_reg : 16'd0;
    end
end

endmodule