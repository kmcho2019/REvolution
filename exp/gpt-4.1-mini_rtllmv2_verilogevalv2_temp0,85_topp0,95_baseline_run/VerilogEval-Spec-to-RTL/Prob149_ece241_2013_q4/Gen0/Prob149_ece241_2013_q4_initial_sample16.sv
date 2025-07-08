module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [2:0]  s,
    output reg         fr2,
    output reg         fr1,
    output reg         fr0,
    output reg         dfr
);

    // Register to hold previous sensor state
    reg [2:0] prev_s;

    // Function to count number of sensors asserted (to compare levels)
    function [1:0] count_asserted;
        input [2:0] val;
        begin
            count_asserted = val[0] + val[1] + val[2];
        end
    endfunction

    // Determine nominal flow signals and dfr on clock edge
    always @(posedge clk) begin
        if (reset) begin
            // Reset state: level below lowest sensor (no sensors asserted)
            // All outputs asserted (fr0, fr1, fr2, dfr)
            prev_s <= 3'b000;
            fr0    <= 1'b1;
            fr1    <= 1'b1;
            fr2    <= 1'b1;
            dfr    <= 1'b1;
        end else begin
            // Nominal flow signals according to sensor pattern s
            case (s)
                3'b111: begin
                    // Above s2: no nominal flow valves
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                3'b011: begin
                    // Between s2 and s1: fr0
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                3'b001: begin
                    // Between s1 and s0: fr0, fr1
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                3'b000: begin
                    // Below s0: fr0, fr1, fr2
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    // Other cases: treat conservatively (nominal off)
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
            endcase

            // Determine if water level increased since last sensor change:
            // Compare count of asserted sensors previous vs current.
            // If current count > previous count, level increased.
            if (count_asserted(s) > count_asserted(prev_s))
                dfr <= 1'b1;
            else
                dfr <= 1'b0;

            // Store current sensor pattern for next cycle
            prev_s <= s;
        end
    end

endmodule