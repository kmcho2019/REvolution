module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] prev_s;
    wire water_rising;

    // Store previous sensor values for rising detection
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Rising detection: current level higher than previous
    assign water_rising = ((s > prev_s) && !reset);

    // Output logic:
    // fr0: asserted when not above s[2] (all sensors on)
    assign fr0 = reset ? 1'b1 : (s != 3'b111);

    // fr1: asserted when at least s[0] is not covered (below s[1])
    assign fr1 = reset ? 1'b1 : (s[1:0] != 2'b11);

    // fr2: asserted only when below s[0] (no sensors on)
    assign fr2 = reset ? 1'b1 : (s == 3'b000);

    // dfr: supplemental flow when rising and not at highest level
    assign dfr = reset ? 1'b1 : (water_rising && (s != 3'b111));

endmodule