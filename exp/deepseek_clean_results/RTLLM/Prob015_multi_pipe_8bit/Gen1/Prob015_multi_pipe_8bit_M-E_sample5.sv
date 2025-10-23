module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline enable signals (4 stages)
    reg [3:0] enable_pipe;

    // Stage 1: Input registers and partial products
    reg [7:0] a_reg, b_reg;
    wire [15:0] pp [7:0];  // Properly shifted partial products

    // Stage 2: First level compression
    reg [15:0] sum_stage2, carry_stage2;

    // Stage 3: Second level compression
    reg [15:0] sum_stage3, carry_stage3;

    // Stage 4: Final product
    reg [15:0] product_reg;

    // Generate properly shifted partial products
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate

    // Wallace tree compression functions
    function automatic [15:0] wallace_3_2;
        input [15:0] a, b, c;
        begin
            wallace_3_2 = a ^ b ^ c;  // Sum
        end
    endfunction

    function automatic [15:0] wallace_carry_3_2;
        input [15:0] a, b, c;
        begin
            wallace_carry_3_2 = (a & b) | (a & c) | (b & c);  // Carry
        end
    endfunction

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable_pipe <= 4'b0;
        end else begin
            enable_pipe <= {enable_pipe[2:0], mul_en_in};
        end
    end

    // Stage 1: Input sampling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
        end else if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end
    end

    // Stage 2: First level Wallace compression
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 16'b0;
            carry_stage2 <= 16'b0;
        end else if (enable_pipe[0]) begin
            // Compress 8 partial products to 6
            sum_stage2 <= wallace_3_2(pp[0], pp[1], pp[2]);
            carry_stage2 <= wallace_carry_3_2(pp[0], pp[1], pp[2]) << 1;
        end
    end

    // Stage 3: Second level Wallace compression
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3 <= 16'b0;
            carry_stage3 <= 16'b0;
        end else if (enable_pipe[1]) begin
            // Compress intermediate sums to final sum+carry pair
            sum_stage3 <= sum_stage2 ^ carry_stage2 ^ pp[3];
            carry_stage3 <= ((sum_stage2 & carry_stage2) | 
                           (sum_stage2 & pp[3]) | 
                           (carry_stage2 & pp[3])) << 1;
        end
    end

    // Stage 4: Final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= 16'b0;
        end else if (enable_pipe[2]) begin
            product_reg <= sum_stage3 + carry_stage3;
        end
    end

    // Output assignments
    assign mul_en_out = enable_pipe[3];
    assign mul_out = mul_en_out ? product_reg : 16'b0;

endmodule