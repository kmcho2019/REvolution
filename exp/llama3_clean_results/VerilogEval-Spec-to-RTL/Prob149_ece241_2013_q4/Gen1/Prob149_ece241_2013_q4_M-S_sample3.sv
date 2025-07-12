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
        // Determine the flow rate based on the water level sensors
        case (s)
            3'b111: begin // Above s[2], no flow
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
            3'b110: begin // Between s[2] and s[1], nominal flow
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            3'b100: begin // Between s[1] and s[0], nominal flow
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            default: begin // Below s[0], max flow
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
        endcase

        // Determine if the water level has increased
        if (s > prev_s) begin
            // Open the Supplemental flow valve
            dfr <= 1'b1;
        end else begin
            // Close the Supplemental flow valve
            dfr <= 1'b0;
        end

        // Update the previous sensor state
        prev_s <= s;
    end
end

endmodule