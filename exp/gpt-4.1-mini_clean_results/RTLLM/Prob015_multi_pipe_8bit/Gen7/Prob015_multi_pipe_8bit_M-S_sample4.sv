module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable shift register for 3-stage pipeline
    reg [2:0] en_pipe;

    // Input registers: latch inputs when mul_en_in asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires (16-bit each)
    wire [15:0] pp[7:0];
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : PP_GEN
            assign pp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Pipeline stage 1: sum partial products in two groups to reduce adder size
    reg [15:0] sum_low;  // sum of pp[0] to pp[3]
    reg [15:0] sum_high; // sum of pp[4] to pp[7]

    // Pipeline stage 2: sum stage 1 outputs to get final product
    reg [15:0] mul_out_reg;

    // 1) Enable shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            en_pipe <= 3'd0;
        else
            en_pipe <= {en_pipe[1:0], mul_en_in};
    end

    // 2) Sample inputs when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Stage 1: sum partial products in halves and register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_low <= 16'd0;
            sum_high <= 16'd0;
        end else if (en_pipe[0]) begin
            sum_low <= pp[0] + pp[1] + pp[2] + pp[3];
            sum_high <= pp[4] + pp[5] + pp[6] + pp[7];
        end else begin
            sum_low <= 16'd0;
            sum_high <= 16'd0;
        end
    end

    // 4) Stage 2: sum halves and register final output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (en_pipe[1])
            mul_out_reg <= sum_low + sum_high;
        else
            mul_out_reg <= 16'd0;
    end

    // Output enable is MSB of enable shift register (3-cycle latency)
    assign mul_en_out = en_pipe[2];

    // Output product valid only when mul_en_out asserted, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule