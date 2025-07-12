module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers for enable signal
    reg [3:0] enable_pipe;

    // Input registers
    reg [7:0] a_reg, b_reg;

    // Partial product wires
    wire [7:0] pp [7:0];

    // Pipeline registers for partial sums
    reg [8:0] sum_stage1 [3:0];
    reg [10:0] sum_stage2 [1:0];
    reg [15:0] sum_final;

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? a_reg : 8'b0;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            enable_pipe <= 4'b0;
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            
            // Reset pipeline stages
            sum_stage1[0] <= 9'b0;
            sum_stage1[1] <= 9'b0;
            sum_stage1[2] <= 9'b0;
            sum_stage1[3] <= 9'b0;
            
            sum_stage2[0] <= 11'b0;
            sum_stage2[1] <= 11'b0;
            
            sum_final <= 16'b0;
        end else begin
            // Pipeline enable signal
            enable_pipe <= {enable_pipe[2:0], mul_en_in};

            // Stage 1: Sample inputs and generate first partial sums
            if (enable_pipe[0]) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end

            // Stage 2: First level additions
            if (enable_pipe[1]) begin
                sum_stage1[0] <= {1'b0, pp[0]} + {pp[1], 1'b0};
                sum_stage1[1] <= {1'b0, pp[2]} + {pp[3], 1'b0};
                sum_stage1[2] <= {1'b0, pp[4]} + {pp[5], 1'b0};
                sum_stage1[3] <= {1'b0, pp[6]} + {pp[7], 1'b0};
            end

            // Stage 3: Second level additions
            if (enable_pipe[2]) begin
                sum_stage2[0] <= {2'b00, sum_stage1[0]} + {sum_stage1[1], 2'b00};
                sum_stage2[1] <= {2'b00, sum_stage1[2]} + {sum_stage1[3], 2'b00};
            end

            // Stage 4: Final accumulation
            if (enable_pipe[3]) begin
                sum_final <= {4'b0000, sum_stage2[0]} + {sum_stage2[1], 4'b0000};
            end
        end
    end

    // Output assignments
    assign mul_en_out = enable_pipe[3];
    assign mul_out = mul_en_out ? sum_final : 16'b0;

endmodule