module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // 7-bit shift register to track last 7 inputs
    reg [6:0] history;

    // Pattern detection wires
    wire discard_pattern = (history[5:0] == 6'b111110) && !in;
    wire flag_pattern = (history == 7'b1111110);
    wire error_pattern = (history == 7'b1111111);

    // Edge detection for single-cycle pulses
    reg prev_discard, prev_flag, prev_err;

    always @(posedge clk) begin
        if (reset) begin
            history <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
            prev_discard <= 0;
            prev_flag <= 0;
            prev_err <= 0;
        end else begin
            // Update history shift register
            history <= {history[5:0], in};

            // Store previous detection states
            prev_discard <= discard_pattern;
            prev_flag <= flag_pattern;
            prev_err <= error_pattern;

            // Generate single-cycle pulses on pattern detection
            disc <= discard_pattern && !prev_discard;
            flag <= flag_pattern && !prev_flag;
            err <= error_pattern && !prev_err;
        end
    end

endmodule