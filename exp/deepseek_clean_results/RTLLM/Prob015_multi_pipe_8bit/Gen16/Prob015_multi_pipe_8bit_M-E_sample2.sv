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
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp [7:0];  // Partial products
    reg [15:0] sum1, carry1;
    reg [15:0] sum2, carry2;
    reg [15:0] result;
    reg [3:0] en_pipe;

    // Generate all partial products
    always @(*) begin
        for (integer i = 0; i < 8; i = i + 1) begin
            pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
        end
    end

    // Wallace Tree compression stages
    // First compression layer (3:2 compressors)
    wire [15:0] s1_0, c1_0, s1_1, c1_1, s1_2, c1_2;
    compressor_3to2 c0 (pp[0], pp[1], pp[2], s1_0, c1_0);
    compressor_3to2 c1 (pp[3], pp[4], pp[5], s1_1, c1_1);
    compressor_3to2 c2 (pp[6], pp[7], 16'b0, s1_2, c1_2);

    // Second compression layer
    wire [15:0] s2_0, c2_0;
    compressor_3to2 c3 (s1_0, c1_0 << 1, s1_1, s2_0, c2_0);

    // Final addition
    wire [15:0] final_sum = (s2_0 + (c2_0 << 1) + (s1_2 << 6) + (c1_1 << 3) + (c1_2 << 7);

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            sum1 <= 16'b0;
            carry1 <= 16'b0;
            sum2 <= 16'b0;
            carry2 <= 16'b0;
            result <= 16'b0;
            en_pipe <= 4'b0;
        end else begin
            // Stage 1: Register inputs and generate PPs
            if (mul_en_in || !en_pipe[0]) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end

            // Stage 2: First compression results
            sum1 <= s1_0 + s1_1;
            carry1 <= (c1_0 << 1) + (c1_1 << 1);

            // Stage 3: Second compression results
            sum2 <= s2_0;
            carry2 <= c2_0 << 1;

            // Stage 4: Final result
            result <= final_sum;

            // Enable pipeline
            en_pipe <= {en_pipe[2:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipe[3];
    assign mul_out = en_pipe[3] ? result : 16'b0;

endmodule

// 3:2 Compressor module
module compressor_3to2(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = ((a & b) | (a & c) | (b & c)) << 1;
endmodule