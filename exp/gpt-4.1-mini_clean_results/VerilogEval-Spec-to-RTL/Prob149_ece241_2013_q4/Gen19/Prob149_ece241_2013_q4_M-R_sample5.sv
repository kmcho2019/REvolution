module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    reg [2:0] prev_s;

    // Count how many sensors are asserted - used as numeric water level measure
    wire [1:0] current_level = s[0] + s[1] + s[2];
    wire [1:0] prev_level    = prev_s[0] + prev_s[1] + prev_s[2];

    // Track previous sensor state synchronously with reset
    always @(posedge clk) begin
        if (reset)
            prev_s <= 3'b000;  // Represents water below lowest sensor, max flow state
        else
            prev_s <= s;
    end

    // dfr asserted if current water level (number of asserted sensors) is higher than previous
    assign dfr = (current_level > prev_level);

    // Nominal flow rates assigned combinationally by matching current sensor pattern
    // Using conditions exactly as per problem statement:
    // Above s[2]: s=111 -> no nominal flow
    // Between s[2] and s[1]: s=011 -> fr0 only
    // Between s[1] and s[0]: s=001 -> fr0, fr1
    // Below s[0]: s=000 -> fr0, fr1, fr2
    // No other sensor combinations expected per spec
    assign {fr2, fr1, fr0} = (s == 3'b111) ? 3'b000 :
                            (s == 3'b011) ? 3'b001 :
                            (s == 3'b001) ? 3'b011 :
                            /* default or s == 3'b000 */ 3'b111;

endmodule