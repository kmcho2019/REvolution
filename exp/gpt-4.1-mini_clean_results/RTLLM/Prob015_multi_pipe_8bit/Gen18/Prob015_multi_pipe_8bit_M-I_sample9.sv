module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_pipe_1;

    // Pipeline enable register: 5 stages total
    reg [4:0] mul_en_pipe;

    // Stage 2: Generate partial products and sum pairs
    reg [15:0] pp [7:0];
    reg [15:0] sum2 [3:0]; // sums of pairs of partial products (8->4)

    // Stage 3: sum 4 partial sums into 2 sums
    reg [15:0] sum3 [1:0];

    // Stage 4: sum 2 sums into final product (before output register)
    reg [15:0] sum4;

    // Stage 5: output register
    reg [15:0] mul_out_reg;

    integer i;

    // Stage 1: Input registers and enable pipeline stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_pipe_1 <= 1'b0;
            mul_en_pipe <= 5'b0;
        end else begin
            // latch inputs only if mul_en_in asserted
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            mul_en_pipe_1 <= mul_en_in;
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_pipe_1}; // shift enable pipeline
        end
    end

    // Stage 2: Generate 8 partial products and sum pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<8; i=i+1) begin
                pp[i] <= 16'd0;
            end
            for (i=0; i<4; i=i+1) begin
                sum2[i] <= 16'd0;
            end
        end else begin
            // Generate partial products only if enable stage 1 asserted
            if (mul_en_pipe_1) begin
                for (i=0; i<8; i=i+1) begin
                    pp[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
                end
            end else begin
                for (i=0; i<8; i=i+1) begin
                    pp[i] <= 16'd0;
                end
            end
            // Sum pairs of partial products: (0+1), (2+3), (4+5), (6+7)
            sum2[0] <= pp[0] + pp[1];
            sum2[1] <= pp[2] + pp[3];
            sum2[2] <= pp[4] + pp[5];
            sum2[3] <= pp[6] + pp[7];
        end
    end

    // Stage 3: sum 4 sums into 2 sums: (sum2[0]+sum2[1]), (sum2[2]+sum2[3])
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum3[0] <= 16'd0;
            sum3[1] <= 16'd0;
        end else begin
            sum3[0] <= sum2[0] + sum2[1];
            sum3[1] <= sum2[2] + sum2[3];
        end
    end

    // Stage 4: sum 2 sums into final product before output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum4 <= 16'd0;
        end else begin
            sum4 <= sum3[0] + sum3[1];
        end
    end

    // Stage 5: output register for final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else begin
            if (mul_en_pipe[3]) begin
                mul_out_reg <= sum4;
            end else begin
                mul_out_reg <= 16'd0;
            end
        end
    end

    // Output enable is MSB of enable pipeline (5-stage latency)
    assign mul_en_out = mul_en_pipe[4];

    // Output mux
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule