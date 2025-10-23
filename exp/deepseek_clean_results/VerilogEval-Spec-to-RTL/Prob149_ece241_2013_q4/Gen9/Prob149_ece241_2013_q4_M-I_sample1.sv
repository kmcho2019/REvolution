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
    reg rising;

    // State encoding based on sensor readings:
    // 000 - Below s[0] (no sensors)
    // 001 - Between s[0] and s[1] (only s[0])
    // 011 - Between s[1] and s[2] (s[0] and s[1])
    // 111 - Above s[2] (all sensors)
    // Other patterns are invalid and treated conservatively

    always @(posedge clk) begin
        if (reset) begin
            // Reset to state equivalent to long-time low water level
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            prev_s <= 3'b000;
            rising <= 1'b0;
        end else begin
            // Detect rising water level (any sensor newly asserted)
            rising <= (s & ~prev_s) != 3'b000;
            prev_s <= s;

            // Output logic based on current sensor readings
            case (s)
                3'b000: begin // Below s[0]
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= rising;
                end
                3'b001: begin // Between s[0] and s[1]
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= rising;
                end
                3'b011: begin // Between s[1] and s[2]
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= rising;
                end
                3'b111: begin // Above s[2]
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
                default: begin // Handle invalid sensor patterns conservatively
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
            endcase
        end
    end

endmodule