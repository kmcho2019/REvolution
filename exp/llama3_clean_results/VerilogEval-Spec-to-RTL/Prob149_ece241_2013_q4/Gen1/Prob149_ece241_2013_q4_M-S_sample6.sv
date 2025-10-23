module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @(posedge clk) begin
    if (reset) begin
        // Reset state: water level is low, all outputs asserted
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Update previous sensor state
        prev_s <= s;

        // Determine flow rates based on sensor inputs
        if (s == 3'b111) begin
            // Above s[2], no flow
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
        end else if (s == 3'b110) begin
            // Between s[2] and s[1], nominal flow
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end else if (s == 3'b100) begin
            // Between s[1] and s[0], nominal flow
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else begin
            // Below s[0] or no sensors asserted, max flow
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end

        // Determine Supplemental flow valve status
        if ((prev_s < s) && (s != 3'b111)) begin
            // Sensor change indicates previous level was lower than current level
            dfr <= 1'b1;
        end else begin
            dfr <= (s == 3'b000) ? 1'b1 : 1'b0;
        end
    end
end

endmodule