module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register (4 stages)
    reg [3:0] mul_en_pipe;

    // Stage 1 registers: inputs and enable
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2 registers: partial sums lower 4 bits of multiplier
    reg [11:0] partial_sum_lower;   // max 8 bits shifted by up to 3 -> max 11 bits needed
    reg        stage2_en;

    // Stage 3 registers: partial sums upper 4 bits of multiplier
    reg [11:0] partial_sum_upper;   // similar width as lower partial sum
    reg        stage3_en;

    // Stage 4 register: final product sum (adding lower and upper partial sums)
    reg [15:0] mul_out_reg;
    reg        stage4_en;

    // Generate partial products for lower 4 bits (b[3:0])
    wire [11:0] pp_lower [3:0];
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : gen_pp_lower
            // Each partial product is mul_a shifted by i bits if b[i] is 1
            assign pp_lower[i] = mul_b_reg[i] ? (mul_a_reg << i) : 12'd0;
        end
    endgenerate

    // Generate partial products for upper 4 bits (b[7:4]), shifted by 4 bits left additionally
    wire [11:0] pp_upper [3:0];
    generate
        for (i=0; i<4; i=i+1) begin : gen_pp_upper
            // multiply upper bits and shift left by (i+4)
            assign pp_upper[i] = mul_b_reg[i+4] ? (mul_a_reg << (i+4)) : 12'd0;
        end
    endgenerate

    // Stage 1: Sample inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if(mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: Sum lower 4 partial products (12-bit width)
    // Register sums and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_sum_lower <= 12'd0;
            stage2_en <= 1'b0;
        end else begin
            if(mul_en_pipe[0]) begin
                partial_sum_lower <= pp_lower[0] + pp_lower[1] + pp_lower[2] + pp_lower[3];
            end else begin
                partial_sum_lower <= 12'd0;
            end
            stage2_en <= mul_en_pipe[0];
        end
    end

    // Stage 3: Sum upper 4 partial products (12-bit width)
    // Register sums and enable
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            partial_sum_upper <= 12'd0;
            stage3_en <= 1'b0;
        end else begin
            if(stage2_en) begin
                partial_sum_upper <= pp_upper[0] + pp_upper[1] + pp_upper[2] + pp_upper[3];
            end else begin
                partial_sum_upper <= 12'd0;
            end
            stage3_en <= stage2_en;
        end
    end

    // Stage 4: Add upper and lower partial sums to get final product
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mul_out_reg <= 16'd0;
            stage4_en <= 1'b0;
        end else begin
            if(stage3_en) begin
                mul_out_reg <= {4'd0, partial_sum_lower} + {4'd0, partial_sum_upper}; 
                // zero extend 12-bit sums to 16-bit before addition
            end else begin
                mul_out_reg <= 16'd0;
            end
            stage4_en <= stage3_en;
        end
    end

    // Output enable is the final pipeline enable bit
    assign mul_en_out = stage4_en;

    // Output product valid only if mul_en_out is high
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule