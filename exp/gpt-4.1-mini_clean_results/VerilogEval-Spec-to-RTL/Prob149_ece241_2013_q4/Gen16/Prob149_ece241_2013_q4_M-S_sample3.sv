module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Determine water level by counting asserted sensors from bottom
    wire [1:0] level = (s[0] ? 1 : 0) + (s[1] ? 1 : 0) + (s[2] ? 1 : 0);

    reg [1:0] prev_level;

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0; // Initialize as if below s[0]
            dfr <= 1'b1;        // Supplemental flow valve open on reset
        end else begin
            dfr <= (level > prev_level) ? 1'b1 : 1'b0;
            prev_level <= level;
        end
    end

    // Nominal flow valves assigned combinationally per current level
    // Level 3 (above s[2]): none asserted (all zero)
    // Level 2 (between s[2] and s[1]): fr0 asserted
    // Level 1 (between s[1] and s[0]): fr0 and fr1 asserted
    // Level 0 (below s[0]): fr0, fr1, fr2 asserted
    assign fr0 = (level != 2'd3);
    assign fr1 = (level <= 2'd1);
    assign fr2 = (level == 2'd0);

endmodule