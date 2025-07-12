module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level states encoding:
    // 2'd0 = Below s[0]
    // 2'd1 = Between s[1] and s[0]
    // 2'd2 = Between s[2] and s[1]
    // 2'd3 = Above s[2]

    reg [1:0] prev_level;

    // Function to decode sensors into water level state
    function [1:0] sensor_to_level;
        input [2:0] sens;
        begin
            case (sens)
                3'b111: sensor_to_level = 2'd3; // Above s[2]
                3'b011: sensor_to_level = 2'd2; // Between s[2] and s[1]
                3'b001: sensor_to_level = 2'd1; // Between s[1] and s[0]
                3'b000: sensor_to_level = 2'd0; // Below s[0]
                default: sensor_to_level = 2'd0; // Conservatively treat others as Below s[0]
            endcase
        end
    endfunction

    wire [1:0] curr_level = sensor_to_level(s);

    // dfr signal asserted if current water level > previous water level
    wire rising_level = (curr_level > prev_level);

    // Synchronous process to store previous water level state
    always @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0; // reset to Below s[0]
        else
            prev_level <= curr_level;
    end

    // dfr asserted combinationally based on level comparison
    assign dfr = rising_level ? 1'b1 : 1'b0;

    // Flow rate outputs assigned combinationally based on current water level
    assign {fr2, fr1, fr0} = (curr_level == 2'd3) ? 3'b000 : // Above s[2]
                            (curr_level == 2'd2) ? 3'b001 :  // Between s[2] and s[1]
                            (curr_level == 2'd1) ? 3'b011 :  // Between s[1] and s[0]
                            3'b111;                          // Below s[0] and default

endmodule