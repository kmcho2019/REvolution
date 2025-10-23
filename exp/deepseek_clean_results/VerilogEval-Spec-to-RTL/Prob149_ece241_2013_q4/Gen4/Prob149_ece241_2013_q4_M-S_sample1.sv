module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] prev_s;
    reg rising;

    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            rising <= 1'b0;
        end else begin
            // Detect if water level is rising (more sensors are active now)
            rising <= (s > prev_s);
            prev_s <= s;
        end
    end

    // Output logic based directly on current sensor readings
    assign fr0 = reset | (~s[2] & ~s[1] & ~s[0]) |  // Below s[0]
                (~s[2] & ~s[1] & s[0]) |  // Between s[1] and s[0]
                (~s[2] & s[1] & s[0]);    // Between s[2] and s[1]

    assign fr1 = reset | (~s[2] & ~s[1] & ~s[0]) |  // Below s[0]
                (~s[2] & ~s[1] & s[0]);   // Between s[1] and s[0]

    assign fr2 = reset | (~s[2] & ~s[1] & ~s[0]);   // Below s[0]

    assign dfr = rising & ~reset;

endmodule