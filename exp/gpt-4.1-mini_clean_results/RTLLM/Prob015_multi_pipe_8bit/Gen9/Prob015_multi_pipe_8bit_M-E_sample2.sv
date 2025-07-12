module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable shift register for 5-stage pipeline latency (input + 4 accumulation stages)
    reg [4:0] en_pipe;

    // Stage 0: input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1 partial sum register
    reg [15:0] sum_stage1;

    // Stage 2 partial sum register
    reg [15:0] sum_stage2;

    // Stage 3 partial sum register
    reg [15:0] sum_stage3;

    // Stage 4 partial sum register (final product)
    reg [15:0] mul_out_reg;

    // Helper function: generate partial product of mul_a shifted by shift amount if any multiplier bit is set
    // For two bits of multiplier slice, generate partial product accordingly
    function [15:0] partial_product_2bits;
        input [7:0] a;
        input [1:0] b_2bits;
        input integer shift;
        reg [15:0] res;
        begin
            res = 16'd0;
            if(b_2bits[0]) res = res + (a << shift);
            if(b_2bits[1]) res = res + (a << (shift + 1));
            partial_product_2bits = res;
        end
    endfunction

    // 1) Synchronous active-low reset and enable shift register
    always @(posedge clk) begin
        if(!rst_n)
            en_pipe <= 5'd0;
        else
            en_pipe <= {en_pipe[3:0], mul_en_in};
    end

    // 2) Register inputs when mul_en_in asserted
    always @(posedge clk) begin
        if(!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Stage 1: multiply bits [1:0] of multiplier and accumulate starting from zero
    wire [15:0] pp_stage1;
    assign pp_stage1 = partial_product_2bits(mul_a_reg, mul_b_reg[1:0], 0);

    always @(posedge clk) begin
        if(!rst_n)
            sum_stage1 <= 16'd0;
        else if(en_pipe[0])
            sum_stage1 <= pp_stage1;
        else
            sum_stage1 <= 16'd0;
    end

    // 4) Stage 2: multiply bits [3:2], add shifted previous sum by 2 bits
    wire [15:0] pp_stage2;
    assign pp_stage2 = partial_product_2bits(mul_a_reg, mul_b_reg[3:2], 2);

    always @(posedge clk) begin
        if(!rst_n)
            sum_stage2 <= 16'd0;
        else if(en_pipe[1])
            sum_stage2 <= sum_stage1 + pp_stage2;
        else
            sum_stage2 <= 16'd0;
    end

    // 5) Stage 3: multiply bits [5:4], add shifted previous sum by 2 bits
    wire [15:0] pp_stage3;
    assign pp_stage3 = partial_product_2bits(mul_a_reg, mul_b_reg[5:4], 4);

    always @(posedge clk) begin
        if(!rst_n)
            sum_stage3 <= 16'd0;
        else if(en_pipe[2])
            sum_stage3 <= sum_stage2 + pp_stage3;
        else
            sum_stage3 <= 16'd0;
    end

    // 6) Stage 4: multiply bits [7:6], add shifted previous sum by 2 bits, final product
    wire [15:0] pp_stage4;
    assign pp_stage4 = partial_product_2bits(mul_a_reg, mul_b_reg[7:6], 6);

    always @(posedge clk) begin
        if(!rst_n)
            mul_out_reg <= 16'd0;
        else if(en_pipe[3])
            mul_out_reg <= sum_stage3 + pp_stage4;
        else
            mul_out_reg <= 16'd0;
    end

    // Output enable is MSB of enable shift register (5-cycle latency)
    assign mul_en_out = en_pipe[4];

    // Output product only valid if mul_en_out asserted, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule