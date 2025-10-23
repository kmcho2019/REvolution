module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline enable signals (3 stages)
    reg [2:0] enable_pipe;

    // Stage 1: Input registers
    reg [7:0] a_reg, b_reg;

    // Stage 2: Shift-add accumulator
    reg [15:0] accumulator;
    reg [2:0] bit_counter;

    // Stage 3: Output register
    reg [15:0] product_reg;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable_pipe <= 3'b0;
        end else begin
            enable_pipe <= {enable_pipe[1:0], mul_en_in};
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

    // Stage 2: Shift-add accumulation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 16'b0;
            bit_counter <= 3'b0;
        end else if (enable_pipe[0]) begin
            if (bit_counter == 0) begin
                // Initialize accumulation
                accumulator <= b_reg[0] ? {8'b0, a_reg} : 16'b0;
                bit_counter <= 3'd1;
            end else if (bit_counter < 8) begin
                // Accumulate shifted values
                accumulator <= accumulator + (b_reg[bit_counter] ? ({8'b0, a_reg} << bit_counter) : 16'b0);
                bit_counter <= bit_counter + 1;
            end
        end
    end

    // Stage 3: Output registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= 16'b0;
        end else if (enable_pipe[1] && (bit_counter == 8)) begin
            product_reg <= accumulator;
        end
    end

    // Output assignments
    assign mul_en_out = enable_pipe[2];
    assign mul_out = mul_en_out ? product_reg : 16'b0;

endmodule