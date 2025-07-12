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
            // Reset to maximum flow (all outputs high)
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            prev_s <= 3'b000;
        end else begin
            // Store previous sensor state
            prev_s <= s;

            // Nominal flow outputs
            fr0 <= ~s[2];                     // fr0 on unless above s[2]
            fr1 <= ~(s[2] | s[1]);            // fr1 on when below s[1]
            fr2 <= ~(s[2] | s[1] | s[0]);     // fr2 on when below s[0]

            // Supplemental flow (dfr) when level was previously lower
            // True if any higher sensor was previously off but now on
            dfr <= (s[2] & ~prev_s[2]) ||     // rose above s[2]
                  (s[1] & ~prev_s[1]) ||     // rose above s[1]
                  (s[0] & ~prev_s[0]);        // rose above s[0]
        end
    end

endmodule