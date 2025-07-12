module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Count how many sensors are asserted from the bottom s[0]
    // 0 sensors asserted: level = 0 (below s[0])
    // 1 sensor (s[0]) asserted: level = 1 (between s[1] and s[0])
    // 2 sensors (s[0],s[1]) asserted: level = 2 (between s[2] and s[1])
    // 3 sensors asserted: level = 3 (above s[2])
    wire [1:0] level = (s[0] ? 1 : 0) + (s[1] ? 1 : 0) + (s[2] ? 1 : 0);

    reg [1:0] prev_level;

    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'd0; // below s[0]
            dfr <= 1'b1;        // supplemental flow valve open on reset
        end else begin
            dfr <= (level > prev_level) ? 1'b1 : 1'b0;
            prev_level <= level;
        end
    end

    // Assign nominal flow valves based on current level
    // Level 3 (above s[2]): no valves open
    // Level 2 (between s[2] and s[1]): fr0 only
    // Level 1 (between s[1] and s[0]): fr0 and fr1
    // Level 0 (below s[0]): fr0, fr1, fr2
    assign fr0 = (level != 2'd3);
    assign fr1 = (level <= 2'd1);
    assign fr2 = (level == 2'd0);

endmodule