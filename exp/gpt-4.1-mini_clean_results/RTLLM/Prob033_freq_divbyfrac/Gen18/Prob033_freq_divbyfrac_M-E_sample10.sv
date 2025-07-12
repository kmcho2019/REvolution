module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Parameters for division by 3.5 = 7/2
    // Use a 5-bit phase accumulator for fine resolution
    localparam ACC_WIDTH = 5;  // 5 bits accumulator (0..31)
    localparam PHASE_MAX = (1 << ACC_WIDTH);

    // Division factor: 3.5 = 7/2
    // Because we increment on both edges, increment = PHASE_MAX / (7) per half clock cycle
    // Explanation:
    // Full period = 7 input clocks = 14 half clocks
    // One full phase rotation = PHASE_MAX
    // So each half clock edge increments by PHASE_MAX / 14 = PHASE_MAX / (7*2)
    // But since we count increments on both edges, increment per half edge = PHASE_MAX / 7

    // Define increment per half clock edge
    localparam PHASE_INC = PHASE_MAX / 7; // increments the phase accumulator

    reg [ACC_WIDTH-1:0] phase_acc;
    reg msb_d; // delayed MSB for edge detection

    // Dual-edge triggered always block
    // This is allowed in some synthesis tools; if unsupported, can be split into two always blocks.
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_acc <= 0;
            clk_div  <= 0;
            msb_d    <= 0;
        end else begin
            // Update phase accumulator with wrap-around
            phase_acc <= phase_acc + PHASE_INC;

            // Detect MSB toggle for output clock toggle
            // MSB is phase_acc[ACC_WIDTH-1]
            // On each phase wrap crossing (MSB toggling), toggle output clock
            if (msb_d ^ phase_acc[ACC_WIDTH-1]) begin
                clk_div <= ~clk_div;
            end

            msb_d <= phase_acc[ACC_WIDTH-1];
        end
    end

endmodule