module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Decode water level from sensors:
    // 0 = Below s[0]: no sensors asserted (s == 3'b000)
    // 1 = Between s[1] and s[0]: only s[0] asserted (s == 3'b001 or 3'b010)
    // 2 = Between s[2] and s[1]: s[0] and s[1] asserted (3'b011 or 3'b100)
    // 3 = Above s[2]: all sensors asserted (3'b111 or others)
    function [1:0] decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b000: decode_level = 2'd0;      // below s[0]
                3'b001,
                3'b010: decode_level = 2'd1;      // between s[1] and s[0]
                3'b011,
                3'b100: decode_level = 2'd2;      // between s[2] and s[1]
                default: decode_level = 2'd3;      // above s[2]
            endcase
        end
    endfunction

    reg [1:0] current_level;
    reg [1:0] previous_level;

    wire [1:0] decoded_level = decode_level(s);

    // Update levels synchronously
    always @(posedge clk) begin
        if (reset) begin
            current_level  <= 2'd0;  // lowest level on reset
            previous_level <= 2'd0;
        end else begin
            if (decoded_level != current_level) begin
                // Sensor reading changed, update previous level first
                previous_level <= current_level;
                current_level  <= decoded_level;
            end else begin
                // No change, hold levels
                current_level  <= current_level;
                previous_level <= previous_level;
            end
        end
    end

    // Outputs based on current level nominal flow
    // fr signals: assert if valve opened
    // Below s[0] (0): fr0=1, fr1=1, fr2=1
    // Between s[1] and s[0] (1): fr0=1, fr1=1, fr2=0
    // Between s[2] and s[1] (2): fr0=1, fr1=0, fr2=0
    // Above s[2] (3): fr0=0, fr1=0, fr2=0
    assign fr0 = (current_level <= 2'd2) ? 1'b1 : 1'b0;
    assign fr1 = (current_level == 2'd0 || current_level == 2'd1) ? 1'b1 : 1'b0;
    assign fr2 = (current_level == 2'd0) ? 1'b1 : 1'b0;

    // Supplemental flow valve dfr is on if level rising
    assign dfr = (current_level > previous_level) ? 1'b1 : 1'b0;

endmodule