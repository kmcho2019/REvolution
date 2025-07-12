module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] stage1_sum [1:0];
    reg [15:0] final_sum;
    reg valid_out;

    // Partial products (combinational)
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = {8'b0, mul_a} & {16{mul_b[i]}} << i;
        end
    endgenerate

    // Stage 1: Parallel prefix adder tree
    wire [15:0] sum0 = pp[0] + pp[1] + pp[2] + pp[3];
    wire [15:0] sum1 = pp[4] + pp[5] + pp[6] + pp[7];

    // Final sum (combinational)
    wire [15:0] next_sum = stage1_sum[0] + stage1_sum[1];

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            stage1_sum[0] <= 16'b0;
            stage1_sum[1] <= 16'b0;
            final_sum <= 16'b0;
            valid_out <= 1'b0;
        end else begin
            // Stage 0: Input sampling
            a_reg <= mul_a;
            b_reg <= mul_b;

            // Stage 1: Intermediate sums
            stage1_sum[0] <= sum0;
            stage1_sum[1] <= sum1;

            // Stage 2: Final result
            final_sum <= next_sum;
            valid_out <= mul_en_in;
        end
    end

    // Output assignments
    assign mul_en_out = valid_out;
    assign mul_out = valid_out ? final_sum : 16'b0;

endmodule