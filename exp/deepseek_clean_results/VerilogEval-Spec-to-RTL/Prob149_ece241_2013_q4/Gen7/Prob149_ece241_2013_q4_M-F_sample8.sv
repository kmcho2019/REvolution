module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;

    // Water level conditions
    wire above_s2      = (s == 3'b111);
    wire between_s2_s1 = (s == 3'b011);
    wire between_s1_s0 = (s == 3'b001);
    wire below_s0      = (s == 3'b000);

    // Water rising detection (current level > previous level)
    wire water_rising = (s > prev_s);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to maximum flow condition (all outputs high)
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            prev_s <= 3'b000;
        end else begin
            // Store previous sensor state
            prev_s <= s;

            // Set flow rate outputs based on current water level
            case (1'b1)
                above_s2: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
                between_s2_s1: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                between_s1_s0: begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                below_s0: begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
            endcase

            // Set supplemental flow valve
            // Assert dfr if water is rising and not at maximum level
            dfr <= water_rising && !above_s2;
        end
    end

endmodule