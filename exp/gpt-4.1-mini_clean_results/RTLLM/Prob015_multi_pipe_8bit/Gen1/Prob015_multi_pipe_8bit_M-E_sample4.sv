module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output              mul_en_out,
    output reg  [15:0]  mul_out
);

    // Pipeline depth = 8 (one stage per multiplier bit)
    // Shift register for output enable signal delayed by 8 cycles
    reg [7:0] mul_en_pipe;

    // Input stage registers (sample inputs on mul_en_in)
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Pipeline registers for intermediate product and multiplier
    // At each stage:
    // product_reg: accumulated partial product (16 bits)
    // mulb_reg: shifted multiplier (8 bits)
    reg [15:0] product_pipe [7:0];
    reg [7:0]  mulb_pipe    [7:0];

    integer i;

    // Input sampling and initial pipeline stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 8'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            mul_out <= 16'b0;
            for (i = 0; i < 8; i = i + 1) begin
                product_pipe[i] <= 16'b0;
                mulb_pipe[i] <= 8'b0;
            end
        end else begin
            // Shift enable pipeline
            mul_en_pipe <= {mul_en_pipe[6:0], mul_en_in};

            // Register inputs when mul_en_in is asserted
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Stage 0: compute first partial product if enabled
            if (mul_en_in) begin
                product_pipe[0] <= (mul_b_reg[0]) ? {8'b0, mul_a_reg} : 16'b0;
                mulb_pipe[0] <= mul_b_reg >> 1;
            end else begin
                product_pipe[0] <= 16'b0;
                mulb_pipe[0] <= 8'b0;
            end

            // Subsequent pipeline stages
            for (i = 1; i < 8; i = i + 1) begin
                // At each stage, add shifted multiplicand if LSB of mulb_pipe[i-1] is set
                product_pipe[i] <= product_pipe[i-1] + ((mulb_pipe[i-1][0]) ? ({8'b0, mul_a_reg} << i) : 16'b0);
                // Shift multiplier right by one bit for next stage
                mulb_pipe[i] <= mulb_pipe[i-1] >> 1;
            end

            // Output assignment: valid when mul_en_pipe[7] is high
            if (mul_en_pipe[7]) begin
                mul_out <= product_pipe[7];
            end else begin
                mul_out <= 16'b0;
            end
        end
    end

    // Output enable signal delayed by 8 cycles
    assign mul_en_out = mul_en_pipe[7];

endmodule