module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial sum register (16 bits) - accumulates partial products
    reg [15:0] partial_sum_reg;

    // Bit position counter register (3 bits) - tracks which multiplier bit to process
    reg [3:0] bit_pos; // 4 bits to count 0..8

    // Enable shift register pipeline (9 bits) to track enable through all stages including output
    reg [8:0] mul_en_pipe;

    // Sample inputs and start multiplication process on mul_en_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 9'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            partial_sum_reg <= 16'd0;
            bit_pos <= 4'd0;
        end else begin
            // Shift enable pipeline, input enable is loaded at LSB
            mul_en_pipe <= {mul_en_pipe[7:0], mul_en_in};

            if (mul_en_in) begin
                // Latch inputs only when new multiplication starts
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
                partial_sum_reg <= 16'd0; // reset accumulator at start
                bit_pos <= 4'd0;
            end else if (mul_en_pipe[0]) begin
                // When enabled in stage 0, process next bit of multiplier
                // Add partial product if multiplier bit set
                if (bit_pos < 8) begin
                    if (mul_b_reg[bit_pos])
                        partial_sum_reg <= partial_sum_reg + (mul_a_reg << bit_pos);
                    bit_pos <= bit_pos + 1;
                end
            end
            // else keep values unchanged when not enabled in pipeline
        end
    end

    // Output enable is the last stage of enable pipeline
    assign mul_en_out = mul_en_pipe[8];

    // Output product is valid when output enable active, else zero
    assign mul_out = mul_en_out ? partial_sum_reg : 16'd0;

endmodule