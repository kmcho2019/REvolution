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
    reg [2:0] enable_pipe;
    reg [7:0] a_pipe, b_pipe;
    reg [7:0] pp [7:0];  // Partial products
    reg [11:0] sum_stage1 [3:0];
    reg [15:0] final_sum;

    // Input stage (Stage 1)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable_pipe <= 3'b0;
            a_pipe <= 8'b0;
            b_pipe <= 8'b0;
        end else begin
            enable_pipe <= {enable_pipe[1:0], mul_en_in};
            
            if (mul_en_in) begin
                a_pipe <= mul_a;
                b_pipe <= mul_b;
            end
        end
    end

    // Partial product generation (Stage 1)
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                pp[i] <= 8'b0;
        end else if (enable_pipe[0]) begin
            for (i = 0; i < 8; i = i + 1)
                pp[i] <= (b_pipe[i]) ? a_pipe << i : 8'b0;
        end
    end

    // First addition stage (Stage 2)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1)
                sum_stage1[i] <= 12'b0;
        end else if (enable_pipe[1]) begin
            sum_stage1[0] <= {4'b0, pp[0]} + {3'b0, pp[1], 1'b0};
            sum_stage1[1] <= {2'b0, pp[2], 2'b0} + {1'b0, pp[3], 3'b0};
            sum_stage1[2] <= pp[4] << 4 + pp[5] << 5;
            sum_stage1[3] <= pp[6] << 6 + pp[7] << 7;
        end
    end

    // Final addition stage (Stage 3)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum <= 16'b0;
        end else if (enable_pipe[2]) begin
            final_sum <= sum_stage1[0] + sum_stage1[1] + sum_stage1[2] + sum_stage1[3];
        end
    end

    // Output assignment
    assign mul_en_out = enable_pipe[2];
    assign mul_out = mul_en_out ? final_sum : 16'b0;

endmodule