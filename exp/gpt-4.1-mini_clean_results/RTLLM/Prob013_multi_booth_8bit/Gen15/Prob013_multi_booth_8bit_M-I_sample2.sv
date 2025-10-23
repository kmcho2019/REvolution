module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,       // multiplicand input (signed)
    input      [7:0]  b,       // multiplier input (signed)
    output reg [15:0] p,       // product output
    output reg        rdy       // ready signal
);

    // State encoding
    localparam IDLE = 1'b0,
               RUN  = 1'b1;

    reg state;

    // Step counter (3 bits sufficient for 5 steps)
    reg [2:0] step;

    // Sign-extended inputs
    reg signed [8:0] multiplicand;  // multiplicand sign-extended to 9 bits
    reg [8:0] multiplier;            // multiplier extended with an appended 0 bit for booth recoding

    // Precomputed multiples of multiplicand for Booth encoding to avoid repeated computations
    // +0, +1*multiplicand, +2*multiplicand, -1*multiplicand, -2*multiplicand
    reg signed [16:0] m_0;  // zero multiple
    reg signed [16:0] m_1;  // +1 * multiplicand
    reg signed [16:0] m_2;  // +2 * multiplicand
    reg signed [16:0] m_n1; // -1 * multiplicand
    reg signed [16:0] m_n2; // -2 * multiplicand

    reg signed [16:0] partial_product;

    // Accumulator register width 17 bits to accommodate maximum signed product bits (16 bits product + sign)
    reg signed [16:0] accumulator;

    // Booth recoding 3 bits extracted per step
    wire [2:0] booth_bits;

    // Assign current Booth bits for step: multiplier bits at positions (2*step +1) down to (2*step -1)
    // For step i: bits = {multiplier[2i+1], multiplier[2i], multiplier[2i-1]}
    // But multiplier is only 9 bits (bits 8 down to 0), so bits outside are assumed 0 for safe indexing

    // To avoid dynamic indexing (which is not supported by Verilog), we implement logic to select bits per step
    reg [2:0] booth_bits_reg;

    always @(*) begin
        // Default bits zero
        booth_bits_reg = 3'b000;
        case(step)
            3'd0: booth_bits_reg = {multiplier[1], multiplier[0], 1'b0};   // b1 b0 b-1=0
            3'd1: booth_bits_reg = {multiplier[3], multiplier[2], multiplier[1]};
            3'd2: booth_bits_reg = {multiplier[5], multiplier[4], multiplier[3]};
            3'd3: booth_bits_reg = {multiplier[7], multiplier[6], multiplier[5]};
            3'd4: booth_bits_reg = {multiplier[8], multiplier[7], multiplier[6]};
            default: booth_bits_reg = 3'b000;
        endcase
    end

    // Booth decoding logic combinational block (without function call)
    // Using same mapping as standard radix-4 Booth
    always @(*) begin
        case(booth_bits_reg)
            3'b000,
            3'b111: partial_product = m_0;   // 0
            3'b001,
            3'b010: partial_product = m_1;   // +1 * multiplicand
            3'b011: partial_product = m_2;   // +2 * multiplicand
            3'b100: partial_product = m_n2;  // -2 * multiplicand
            3'b101,
            3'b110: partial_product = m_n1;  // -1 * multiplicand
            default: partial_product = m_0;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= IDLE;
            step        <= 3'd0;
            // Sign-extend multiplicand and multiplier inputs
            multiplicand <= {a[7], a};
            multiplier   <= {b, 1'b0};  // append zero bit for booth recoding
            // Precompute multiples
            // Extend multiplicand to 17 bits by sign extension
            m_0   <= 17'sd0;
            m_1   <= {{8{multiplicand[8]}}, multiplicand};            // +1 * multiplicand (9 bits to 17 bits)
            m_2   <= {{7{multiplicand[8]}}, multiplicand, 1'b0};      // +2 * multiplicand (shift left by 1)
            m_n1  <= -({{8{multiplicand[8]}}, multiplicand});         // -1 * multiplicand
            m_n2  <= -({{7{multiplicand[8]}}, multiplicand, 1'b0});   // -2 * multiplicand

            accumulator <= 17'sd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                    if (step == 0) begin
                        // stay in IDLE, wait for next cycle to start multiplication
                        // On next cycle, state changes to RUN
                        state <= RUN;
                    end
                end

                RUN: begin
                    if (step < 3'd5) begin
                        // Add partial product shifted left by 2*step
                        // Use non-blocking to prevent race
                        accumulator <= accumulator + (partial_product <<< (2 * step));
                        step <= step + 1'b1;
                    end else begin
                        // Multiplication done, output product and set ready
                        p <= accumulator[15:0]; // lower 16 bits product
                        rdy <= 1'b1;
                        state <= IDLE;
                        step <= 3'd0;
                    end
                end
            endcase
        end
    end

endmodule