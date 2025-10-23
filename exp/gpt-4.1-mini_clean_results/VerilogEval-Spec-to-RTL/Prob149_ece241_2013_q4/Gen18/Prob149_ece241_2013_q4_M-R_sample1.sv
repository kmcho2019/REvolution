module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding:
    // 0 = LOW (below s[0])
    // 1 = MEDIUM_LOW (between s[1] and s[0])
    // 2 = MEDIUM_HIGH (between s[2] and s[1])
    // 3 = HIGH (above s[2])

    reg [1:0] current_level, prev_level;

    // Decode sensors into numeric water level
    // Sensors are asserted when water is above that sensor.
    // According to problem:
    // s==111 -> level 3 (HIGH)
    // s==011 -> level 2 (MEDIUM_HIGH)
    // s==001 -> level 1 (MEDIUM_LOW)
    // s==000 -> level 0 (LOW)
    // Other combinations mapped conservatively to closest valid level
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b111: decode_level = 2'd3; // above s[2]
                3'b011: decode_level = 2'd2; // between s[2] and s[1]
                3'b001: decode_level = 2'd1; // between s[1] and s[0]
                3'b000: decode_level = 2'd0; // below s[0]
                default: begin
                    // If s[0] asserted, treat as MEDIUM_LOW (1)
                    if (sensors[0])
                        decode_level = 2'd1;
                    // Else if s[1] asserted, MEDIUM_HIGH (2)
                    else if (sensors[1])
                        decode_level = 2'd2;
                    // Else if s[2] asserted, HIGH (3)
                    else if (sensors[2])
                        decode_level = 2'd3;
                    else
                        decode_level = 2'd0;
                end
            endcase
        end
    endfunction

    wire [1:0] next_level = decode_level(s);

    // dfr is high one clock cycle when water level rises compared to prev_level
    reg dfr_reg;
    assign dfr = dfr_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to LOW water level (0)
            current_level <= 2'd0;
            prev_level <= 2'd0;
            dfr_reg <= 1'b1;  // as per spec, dfr asserted on reset
        end else begin
            prev_level <= current_level;
            current_level <= next_level;
            // Compare new level to previous level to set dfr
            if (next_level > prev_level)
                dfr_reg <= 1'b1;
            else
                dfr_reg <= 1'b0;
        end
    end

    // Nominal flow outputs based on current_level
    // Mapping from problem:
    // Level 3 (HIGH): fr2=0 fr1=0 fr0=0
    // Level 2 (MEDIUM_HIGH): fr0=1 fr1=0 fr2=0
    // Level 1 (MEDIUM_LOW): fr0=1 fr1=1 fr2=0
    // Level 0 (LOW): fr0=1 fr1=1 fr2=1

    assign fr0 = (current_level <= 2'd2);   // levels 0,1,2 assert fr0
    assign fr1 = (current_level <= 2'd1);   // levels 0,1 assert fr1
    assign fr2 = (current_level == 2'd0);   // only level 0 assert fr2

endmodule