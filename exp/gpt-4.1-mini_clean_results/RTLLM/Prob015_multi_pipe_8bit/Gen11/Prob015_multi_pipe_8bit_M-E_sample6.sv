module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 1 registers: inputs and enable
    reg [7:0] mul_a_s1, mul_b_s1;
    reg       mul_en_s1;

    // Stage 2 registers: partial sums and enable
    reg [11:0] part_sum_low;  // sum of partial products for bits [3:0] of mul_b
    reg [12:0] part_sum_high; // sum of partial products for bits [7:4] of mul_b
    reg        mul_en_s2;

    // Stage 3 registers: final product and enable
    reg [15:0] mul_out_reg;
    reg        mul_en_s3;

    // Stage 2 combinational partial products generation (lower 4 bits)
    wire [15:0] pp_low [3:0];
    integer i;
    generate
        genvar gi;
        for (gi = 0; gi < 4; gi = gi +1) begin : PP_LOW
            assign pp_low[gi] = mul_b_s1[gi] ? (mul_a_s1 << gi) : 16'd0;
        end
    endgenerate

    // Stage 2 combinational partial products generation (upper 4 bits)
    wire [15:0] pp_high [3:0];
    generate
        genvar gj;
        for (gj = 0; gj < 4; gj = gj +1) begin : PP_HIGH
            assign pp_high[gj] = mul_b_s1[gj+4] ? (mul_a_s1 << (gj+4)) : 16'd0;
        end
    endgenerate

    // Stage 2: sum partial products for low and high nibble of multiplier
    wire [15:0] sum_low_16 = pp_low[0] + pp_low[1] + pp_low[2] + pp_low[3];
    wire [15:0] sum_high_16 = pp_high[0] + pp_high[1] + pp_high[2] + pp_high[3];

    // Register inputs at stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_s1 <= 8'd0;
            mul_b_s1 <= 8'd0;
            mul_en_s1 <= 1'b0;
        end else begin
            mul_en_s1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_s1 <= mul_a;
                mul_b_s1 <= mul_b;
            end
        end
    end

    // Stage 2 registers: store partial sums and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            part_sum_low <= 12'd0;
            part_sum_high <= 13'd0;
            mul_en_s2 <= 1'b0;
        end else begin
            // partial sums are at most 12 and 13 bits wide due to addition range
            part_sum_low <= sum_low_16[11:0];
            part_sum_high <= sum_high_16[12:0];
            mul_en_s2 <= mul_en_s1;
        end
    end

    // Stage 3: sum partial sums to get final product
    // part_sum_low covers bits [11:0], part_sum_high covers bits [12:0] and already shifted left by 4 bits
    // Add them to get full 16-bit product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
            mul_en_s3 <= 1'b0;
        end else begin
            // part_sum_high corresponds to partial products shifted by 4 bits (since bits 7:4)
            // so part_sum_high corresponds to bits [16:4], but we only keep lower 13 bits here, so sum accordingly
            mul_out_reg <= {3'd0, part_sum_high} + {4'd0, part_sum_low}; 
            mul_en_s3 <= mul_en_s2;
        end
    end

    // Output enable and product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            mul_en_out <= mul_en_s3;
            mul_out <= mul_en_s3 ? mul_out_reg : 16'd0;
        end
    end

endmodule