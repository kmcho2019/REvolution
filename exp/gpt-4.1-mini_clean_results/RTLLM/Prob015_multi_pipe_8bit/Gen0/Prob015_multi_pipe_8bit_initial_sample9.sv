module multi_pipe_8bit (
    input             clk,
    input             rst_n,
    input             mul_en_in,
    input      [7:0]  mul_a,
    input      [7:0]  mul_b,
    output reg        mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline depth: 4 stages (input register, partial product, partial sums, final sum)
    // Registers for enable signal pipelining
    reg [3:0] mul_en_pipe;

    // Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial product wires: each corresponds to mul_a_reg if mul_b_reg bit is set, shifted accordingly
    wire [15:0] temp [7:0];
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : PARTIAL_PRODUCTS
            assign temp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Sum registers: pipelined partial sum accumulation to avoid long combinational addition
    reg [15:0] sum_stage1;
    reg [15:0] sum_stage2;
    reg [15:0] sum_stage3;

    // Pipeline registers for partial sums
    // Stage1: sum partial products pairwise
    wire [15:0] sum_stage1_next = temp[0] + temp[1] + temp[2] + temp[3];
    wire [15:0] sum_stage1_next_2 = temp[4] + temp[5] + temp[6] + temp[7];

    // Stage 2: sum of stage 1 sums
    wire [15:0] sum_stage2_next = sum_stage1 + sum_stage1_next_2;

    // On each clock cycle, the pipeline moves forward and partial sums accumulate
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'd0;
            mul_a_reg   <= 8'd0;
            mul_b_reg   <= 8'd0;
            sum_stage1  <= 16'd0;
            sum_stage2  <= 16'd0;
            sum_stage3  <= 16'd0;
            mul_out     <= 16'd0;
            mul_en_out  <= 1'b0;
        end else begin
            // Input stage: sample inputs if enabled
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Shift enable signal pipeline
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};

            // Stage 1 sum registers
            // sum_stage1_next sums temp[0..3], sum_stage1_next_2 sums temp[4..7]
            // To pipeline partial sum, break addition into two halves and accumulate over stages
            sum_stage1 <= sum_stage1_next;
            sum_stage2 <= sum_stage1_next_2 + sum_stage1;

            // Stage 3 final sum accumulation
            sum_stage3 <= sum_stage2;

            // Output final product and enable signal after pipeline delay
            mul_out    <= mul_en_pipe[3] ? sum_stage3 : 16'd0;
            mul_en_out <= mul_en_pipe[3];
        end
    end

endmodule