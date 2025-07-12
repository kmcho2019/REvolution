module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Parameters for fractional division by 3.5 = 7/2
    // We'll implement a phase accumulator running at 2x input clk frequency (via clk_en)
    // Increment phase by a fixed value and toggle clk_div on accumulator MSB change

    // Phase accumulator width: use 8 bits for good resolution
    localparam PHASE_WIDTH = 8;

    // To divide input clock by 3.5, period = 3.5 input clocks
    // Since we sample twice per input clock (posedge + negedge),
    // effective "clock" frequency is 2x input clock frequency
    //
    // So output frequency = input_freq / 3.5
    // = input_freq / (7/2)
    // = input_freq * 2 / 7
    //
    // Phase increment = 2^PHASE_WIDTH * output_freq / input_2x_freq
    // input_2x_freq = 2 * input_freq
    // Thus,
    // phase_inc = 2^PHASE_WIDTH * (output_freq / (2*input_freq))
    //            = 2^PHASE_WIDTH * (2/7) / 2
    //            = 2^PHASE_WIDTH / 7
    //
    // phase_inc = floor(256/7) = 36 (approx)

    localparam [PHASE_WIDTH-1:0] PHASE_INCREMENT = 8'd36;

    reg [PHASE_WIDTH-1:0] phase_acc = 0;

    // clk_en toggles on posedge and negedge of clk, creating 2x enable pulses per input clock
    reg clk_en;
    always @(posedge clk or negedge clk) begin
        if (!rst_n)
            clk_en <= 1'b0;
        else
            clk_en <= ~clk_en;
    end

    // Previous MSB of phase accumulator to detect overflow edge
    reg prev_phase_msb;

    always @(posedge clk) begin
        if (!rst_n) begin
            phase_acc    <= 0;
            clk_div     <= 1'b0;
            prev_phase_msb <= 1'b0;
        end else if (clk_en) begin
            // Advance phase accumulator
            {prev_phase_msb, phase_acc} <= {phase_acc[PHASE_WIDTH-1], phase_acc} + PHASE_INCREMENT;

            // Toggle output clock on MSB change (overflow)
            // This implements fractional frequency division with stable duty cycle
            if (phase_acc[PHASE_WIDTH-1] != prev_phase_msb)
                clk_div <= ~clk_div;
        end
    end

endmodule