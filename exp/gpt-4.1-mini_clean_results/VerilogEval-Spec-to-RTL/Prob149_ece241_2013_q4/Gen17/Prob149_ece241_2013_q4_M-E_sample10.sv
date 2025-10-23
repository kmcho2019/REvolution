module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water level encoding:
    // 0 = LOW (below s[0]) = none asserted
    // 1 = MEDIUM_LOW (between s[1] and s[0]) = s[0] only
    // 2 = MEDIUM_HIGH (between s[2] and s[1]) = s[0] & s[1]
    // 3 = HIGH (above s[2]) = all sensors asserted

    reg [1:0] current_level, prev_level;

    // Decode sensor input s into water level number
    // Must handle only valid sensor combinations from spec:
    // s=000 => 0 (LOW)
    // s=001 => 1 (MEDIUM_LOW)
    // s=011 => 2 (MEDIUM_HIGH)
    // s=111 => 3 (HIGH)
    // Others: map conservatively to closest valid level.

    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: decode_level = 2'd0; // LOW
                3'b001: decode_level = 2'd1; // MEDIUM_LOW
                3'b011: decode_level = 2'd2; // MEDIUM_HIGH
                3'b111: decode_level = 2'd3; // HIGH
                default: begin
                    // Conservative mapping:
                    if (sensors == 3'b010) // only s[1]
                        decode_level = 2'd2; // MEDIUM_HIGH
                    else if (sensors == 3'b100) // only s[2]
                        decode_level = 2'd3; // HIGH
                    else if (sensors == 3'b101 || sensors == 3'b110)
                        decode_level = 2'd3; // treat as HIGH
                    else if (sensors & 3'b001) // if s[0] asserted, MEDIUM_LOW
                        decode_level = 2'd1;
                    else
                        decode_level = 2'd0; // else LOW
                end
            endcase
        end
    endfunction

    wire [1:0] sampled_level = decode_level(s);

    // On each clock, update levels and dfr based on level transitions
    always @(posedge clk) begin
        if (reset) begin
            // Reset: simulate low level for long time:
            current_level <= 2'd0;
            prev_level <= 2'd0;
            dfr <= 1'b1; // all flow outputs including dfr asserted on reset
        end else begin
            if (sampled_level != current_level) begin
                prev_level <= current_level;
                current_level <= sampled_level;
                // dfr asserted if water level rose (new > old)
                dfr <= (sampled_level > current_level) ? 1'b1 : 1'b0;
            end else begin
                dfr <= 1'b0;
            end
        end
    end

    // Nominal flow outputs purely combinational from current_level
    // According to table:
    // LOW (0): fr0=1 fr1=1 fr2=1
    // MEDIUM_LOW(1): fr0=1 fr1=1 fr2=0
    // MEDIUM_HIGH(2): fr0=1 fr1=0 fr2=0
    // HIGH(3): all zero

    assign fr0 = (current_level <= 2'd2);          // levels 0,1,2: fr0=1; level 3=0
    assign fr1 = (current_level == 2'd0) || (current_level == 2'd1); // fr1=1 for LOW and MEDIUM_LOW
    assign fr2 = (current_level == 2'd0);           // fr2=1 only for LOW

endmodule