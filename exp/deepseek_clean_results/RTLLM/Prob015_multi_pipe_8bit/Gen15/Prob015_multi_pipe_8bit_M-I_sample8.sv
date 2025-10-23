module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Clock gating logic
    wire clk_gated;
    assign clk_gated = clk & (mul_en_in | (|en_pipeline));

    // Pipeline stage registers with clock gating
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp [0:3];  // Booth-encoded partial products
    reg [15:0] sum_csa1, sum_csa2;
    reg [15:0] result_reg;
    reg [1:0] en_pipeline;  // Reduced from 3 bits

    // Booth encoding for partial products
    wire [8:0] b_ext = {b_reg, 1'b0};
    wire [15:0] a_neg = {8'b0, ~a_reg + 1'b0};
    wire [15:0] a_pos = {8'b0, a_reg};

    // Pipeline control
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            pp[0] <= 16'b0; pp[1] <= 16'b0;
            pp[2] <= 16'b0; pp[3] <= 16'b0;
            sum_csa1 <= 16'b0; sum_csa2 <= 16'b0;
            result_reg <= 16'b0;
            en_pipeline <= 2'b0;
        end else begin
            // Stage 1: Register inputs
            a_reg <= mul_a;
            b_reg <= mul_b;

            // Stage 2: Booth-encoded partial products
            for (integer i = 0; i < 4; i = i+1) begin
                case (b_ext[2*i+1:2*i])
                    2'b01: pp[i] <= (a_pos << (2*i));
                    2'b10: pp[i] <= (a_neg << (2*i));
                    default: pp[i] <= 16'b0;
                endcase
            end

            // Stage 3: Carry-save addition
            {sum_csa1, sum_csa2} <= pp[0] + pp[1] + pp[2] + pp[3];

            // Stage 4: Final addition
            result_reg <= sum_csa1 + sum_csa2;

            // Enable signal pipeline
            en_pipeline <= {en_pipeline[0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[1];
    assign mul_out = en_pipeline[1] ? result_reg : 16'b0;

endmodule