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

    always @(posedge clk) begin
        if (reset) begin
            // Reset to below s[0] state (all outputs high)
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            prev_s <= 3'b000;
        end else begin
            // Store previous sensor state
            prev_s <= s;

            // Nominal flow outputs
            fr0 <= ~s[2] | ~s[1] | ~s[0];  // On unless all sensors are on
            fr1 <= ~s[2] | ~s[1];          // On unless s[2] and s[1] are on
            fr2 <= ~s[2];                   // On unless s[2] is on

            // Supplemental flow (rising water level)
            dfr <= (s > prev_s);            // Current level higher than previous
        end
    end

endmodule