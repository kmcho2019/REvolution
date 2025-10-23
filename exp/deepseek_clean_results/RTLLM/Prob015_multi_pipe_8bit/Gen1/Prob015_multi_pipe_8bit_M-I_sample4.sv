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
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp [7:0];  // Extended to 16-bit for shifts
    reg [15:0] sum_stage1 [1:0]; // Two 16-bit intermediate sums
    reg [15:0] final_sum;

    // Stage 1: Input registration and partial product generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable_pipe <= 3'b0;
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            for (int i=0; i<8; i=i+1) pp[i] <= 16'b0;
        end else begin
            enable_pipe <= {enable_pipe[1:0], mul_en_in};
            
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end

            // Generate partial products with proper shifting
            if (enable_pipe[0]) begin
                for (int i=0; i<8; i=i+1)
                    pp[i] <= b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
            end
        end
    end

    // Stage 2: First level of addition (4+4 partial products)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1[0] <= 16'b0;
            sum_stage1[1] <= 16'b0;
        end else if (enable_pipe[1]) begin
            sum_stage1[0] <= pp[0] + pp[1] + pp[2] + pp[3];
            sum_stage1[1] <= pp[4] + pp[5] + pp[6] + pp[7];
        end
    end

    // Stage 3: Final addition and output registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum <= 16'b0;
        end else if (enable_pipe[2]) begin
            final_sum <= sum_stage1[0] + sum_stage1[1];
        end
    end

    // Output assignment
    assign mul_en_out = enable_pipe[2];
    assign mul_out = mul_en_out ? final_sum : 16'b0;

endmodule