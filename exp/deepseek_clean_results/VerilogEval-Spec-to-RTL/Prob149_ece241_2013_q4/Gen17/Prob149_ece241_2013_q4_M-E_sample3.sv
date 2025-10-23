module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // History buffer for trend detection
    reg [2:0] current_level;
    reg [2:0] prev_level;
    reg [2:0] prev_prev_level;
    wire rising;

    // Update history buffer
    always @(posedge clk) begin
        if (reset) begin
            current_level <= 3'b000;
            prev_level <= 3'b000;
            prev_prev_level <= 3'b000;
        end else begin
            prev_prev_level <= prev_level;
            prev_level <= current_level;
            current_level <= s;
        end
    end

    // Detect rising water level (current > previous)
    assign rising = (current_level > prev_level);

    // Nominal flow outputs (combinational)
    assign fr0 = reset ? 1'b1 : ~(s[2] & s[1] & s[0]);
    assign fr1 = reset ? 1'b1 : ~(s[2] & s[1]) | ~s[0];
    assign fr2 = reset ? 1'b1 : ~(|s);

    // Supplemental flow (active when rising and not at highest level)
    assign dfr = reset ? 1'b1 : (rising & ~(s[2] & s[1] & s[0]));

endmodule