module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register (5 stages)
    reg [4:0] mul_en_pipe;

    // Stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2: Partial product generation (combinational from registered inputs)
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_pp
            assign pp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 3 registers: Add pairs of partial products to get 4 sums
    reg [15:0] sum3_0, sum3_1, sum3_2, sum3_3;
    wire [15:0] sum3_0_next = pp[0] + pp[1];
    wire [15:0] sum3_1_next = pp[2] + pp[3];
    wire [15:0] sum3_2_next = pp[4] + pp[5];
    wire [15:0] sum3_3_next = pp[6] + pp[7];

    // Stage 4 registers: Add pairs of stage 3 sums to get 2 sums
    reg [15:0] sum4_0, sum4_1;
    wire [15:0] sum4_0_next = sum3_0 + sum3_1;
    wire [15:0] sum4_1_next = sum3_2 + sum3_3;

    // Stage 5 register: Final sum to get product
    reg [15:0] mul_out_reg;
    wire [15:0] mul_out_next = sum4_0 + sum4_1;

    // Pipeline registers update and reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 5'd0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            sum3_0 <= 16'd0;
            sum3_1 <= 16'd0;
            sum3_2 <= 16'd0;
            sum3_3 <= 16'd0;
            sum4_0 <= 16'd0;
            sum4_1 <= 16'd0;
            mul_out_reg <= 16'd0;
        end else begin
            // Shift mul_en_in through pipeline
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};

            // Stage 1: sample inputs on mul_en_in
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Stage 3: register partial sums of pairs of partial products
            sum3_0 <= sum3_0_next;
            sum3_1 <= sum3_1_next;
            sum3_2 <= sum3_2_next;
            sum3_3 <= sum3_3_next;

            // Stage 4: register sums of stage 3 pairs
            sum4_0 <= sum4_0_next;
            sum4_1 <= sum4_1_next;

            // Stage 5: register final output sum
            mul_out_reg <= mul_out_next;
        end
    end

    // Output enable aligned with final stage
    assign mul_en_out = mul_en_pipe[4];

    // Output product only valid when enabled, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule