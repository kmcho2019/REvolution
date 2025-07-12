module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @ (posedge clk) begin
    if (reset) begin
        // Reset to initial state (all outputs high, no sensors asserted)
        fr2 <= 1;
        fr1 <= 1;
        fr0 <= 1;
        dfr <= 1;
        prev_s <= 3'b000;
    end else begin
        // Determine the current state based on the sensors
        if (s[2]) begin
            // Water level above s[2], no flow rate
            fr2 <= 0;
            fr1 <= 0;
            fr0 <= 0;
            dfr <= 0;
        end else if (s[1]) begin
            // Water level between s[2] and s[1]
            fr2 <= 0;
            fr1 <= 0;
            fr0 <= 1;
            // Check if the previous level was lower
            if (prev_s < s) begin
                dfr <= 1;
            end else begin
                dfr <= 0;
            end
        end else if (s[0]) begin
            // Water level between s[1] and s[0]
            fr2 <= 0;
            fr1 <= 1;
            fr0 <= 1;
            // Check if the previous level was lower
            if (prev_s < s) begin
                dfr <= 1;
            end else begin
                dfr <= 0;
            end
        end else begin
            // Water level below s[0], maximum flow rate
            fr2 <= 1;
            fr1 <= 1;
            fr0 <= 1;
            dfr <= 1;
        end
        // Update the previous state
        prev_s <= s;
    end
end

endmodule