module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output  reg         mul_en_out,
    output  reg [15:0]  mul_out
);

    // Pipeline depth = 3

    // Stage 1: Register inputs and enable
    reg [7:0] mul_a_r1, mul_b_r1;
    reg       en_r1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_r1 <= 8'd0;
            mul_b_r1 <= 8'd0;
            en_r1    <= 1'b0;
        end else begin
            en_r1    <= mul_en_in;
            if (mul_en_in) begin
                mul_a_r1 <= mul_a;
                mul_b_r1 <= mul_b;
            end
        end
    end

    // Stage 2: Partial product generation (AND gates) and partial sum accumulation
    // Generate partial products (8 x 8 bits)
    wire [7:0] pp [7:0];
    genvar i,j;
    generate
        for(i=0; i<8; i=i+1) begin : PP_GEN_ROW
            for(j=0; j<8; j=j+1) begin : PP_GEN_COL
                assign pp[i][j] = mul_a_r1[j] & mul_b_r1[i];
            end
        end
    endgenerate

    // Partial sums and carry chain registers (for pipelined ripple-carry addition)
    // We'll accumulate each partial product shifted by i bits into a running sum 
    // over 8 cycles, pipelined in one clock stage using registers for carry propagation.
    // To keep pipeline stages per spec, implement all adds combinationally but split into 8 8-bit adders
    // chained with registered carry to break critical path.

    // Shifted partial products aligned into 16-bit wires:
    wire [15:0] pp_shifted [7:0];
    generate
        for(i=0; i<8; i=i+1) begin : PP_SHIFT
            assign pp_shifted[i] = {{8{i+7<15}}{1'b0}, pp[i], {i{1'b0}}}; 
            // actually we want pp[i] at bits [i+7:i], rest zero, so:
            // correct way:
            assign pp_shifted[i] = {8'd0, pp[i]} << i;
        end
    endgenerate

    // Accumulate partial products sequentially using 8-bit adders with pipelined carry
    // We'll implement 8 stages of 8-bit adders to sum lower and upper bytes separately
    // and store carries in registers to break combinational delay.

    // Stage 2 registers to hold intermediate sums and carries
    reg [7:0] sum_lo_r2 [7:0];
    reg [7:0] sum_hi_r2 [7:0];
    reg       carry_r2  [7:0];

    integer k;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for(k=0; k<8; k=k+1) begin
                sum_lo_r2[k] <= 8'd0;
                sum_hi_r2[k] <= 8'd0;
                carry_r2[k]  <= 1'b0;
            end
        end else if(en_r1) begin
            // Accumulate partial products one by one, chain carry to next adder stage

            // First stage: sum pp_shifted[0] with 0
            sum_lo_r2[0] <= pp_shifted[0][7:0];
            sum_hi_r2[0] <= pp_shifted[0][15:8];
            carry_r2[0]  <= 1'b0;

            // Then accumulate from pp_shifted[1] to pp_shifted[7] with sum + carry chaining
            // We'll implement ripple carry by breaking addition per 8-bit segments and register carry

            // We'll define helper variables combinationally for sums
            // But since always block only supports registers, do sums here per cycle:
            // Using a generate-like structure manually unrolled for clarity.

            // k=1
            {carry_r2[1], sum_lo_r2[1]} <= sum_lo_r2[0] + pp_shifted[1][7:0] + carry_r2[0];
            {carry_r2[1], sum_hi_r2[1]} <= sum_hi_r2[0] + pp_shifted[1][15:8] + 0;

            // k=2
            {carry_r2[2], sum_lo_r2[2]} <= sum_lo_r2[1] + pp_shifted[2][7:0] + carry_r2[1];
            {carry_r2[2], sum_hi_r2[2]} <= sum_hi_r2[1] + pp_shifted[2][15:8] + 0;

            // k=3
            {carry_r2[3], sum_lo_r2[3]} <= sum_lo_r2[2] + pp_shifted[3][7:0] + carry_r2[2];
            {carry_r2[3], sum_hi_r2[3]} <= sum_hi_r2[2] + pp_shifted[3][15:8] + 0;

            // k=4
            {carry_r2[4], sum_lo_r2[4]} <= sum_lo_r2[3] + pp_shifted[4][7:0] + carry_r2[3];
            {carry_r2[4], sum_hi_r2[4]} <= sum_hi_r2[3] + pp_shifted[4][15:8] + 0;

            // k=5
            {carry_r2[5], sum_lo_r2[5]} <= sum_lo_r2[4] + pp_shifted[5][7:0] + carry_r2[4];
            {carry_r2[5], sum_hi_r2[5]} <= sum_hi_r2[4] + pp_shifted[5][15:8] + 0;

            // k=6
            {carry_r2[6], sum_lo_r2[6]} <= sum_lo_r2[5] + pp_shifted[6][7:0] + carry_r2[5];
            {carry_r2[6], sum_hi_r2[6]} <= sum_hi_r2[5] + pp_shifted[6][15:8] + 0;

            // k=7
            {carry_r2[7], sum_lo_r2[7]} <= sum_lo_r2[6] + pp_shifted[7][7:0] + carry_r2[6];
            {carry_r2[7], sum_hi_r2[7]} <= sum_hi_r2[6] + pp_shifted[7][15:8] + 0;

        end else begin
            for(k=0; k<8; k=k+1) begin
                sum_lo_r2[k] <= 8'd0;
                sum_hi_r2[k] <= 8'd0;
                carry_r2[k]  <= 1'b0;
            end
        end
    end

    // Stage 3: Final product assembly and output enable signal delayed one more cycle
    reg        en_r3;
    reg [15:0] product_r3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_r3      <= 1'b0;
            product_r3 <= 16'd0;
        end else begin
            en_r3 <= en_r1;
            // Compose final product from sum_lo_r2[7] and sum_hi_r2[7] plus last carry
            // Add final carry to the upper 8 bits:
            // The carry from last adder (carry_r2[7]) should be added at bit 16,
            // but product is 16-bit, so any overflow is discarded

            product_r3 <= {sum_hi_r2[7] + carry_r2[7], sum_lo_r2[7]};
        end
    end

    // Output assignment gated by enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out    <= 16'd0;
        end else begin
            mul_en_out <= en_r3;
            mul_out    <= en_r3 ? product_r3 : 16'd0;
        end
    end

endmodule