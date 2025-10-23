module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water level encoding same as before:
    // 0 = LOW (below s[0]) = none asserted
    // 1 = MEDIUM_LOW (between s[1] and s[0]) = s[0] only
    // 2 = MEDIUM_HIGH (between s[2] and s[1]) = s[0] & s[1]
    // 3 = HIGH (above s[2]) = all sensors asserted

    reg [1:0] current_level, prev_level;

    // Decode sensor input s into water level number (combinational)
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: decode_level = 2'd0; // LOW
                3'b001: decode_level = 2'd1; // MEDIUM_LOW
                3'b011: decode_level = 2'd2; // MEDIUM_HIGH
                3'b111: decode_level = 2'd3; // HIGH
                default: begin
                    if (sensors == 3'b010)
                        decode_level = 2'd2;
                    else if (sensors == 3'b100)
                        decode_level = 2'd3;
                    else if (sensors == 3'b101 || sensors == 3'b110)
                        decode_level = 2'd3;
                    else if (sensors & 3'b001)
                        decode_level = 2'd1;
                    else
                        decode_level = 2'd0;
                end
            endcase
        end
    endfunction

    wire [1:0] sampled_level = decode_level(s);

    // Determine if water level is rising by comparing sampled_level with prev_level before updating
    wire level_rising = (sampled_level > prev_level);

    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'd0;
            prev_level <= 2'd0;
            dfr <= 1'b1;  // On reset, all outputs including dfr asserted
        end else begin
            if (sampled_level != current_level) begin
                prev_level <= current_level;
                current_level <= sampled_level;
                dfr <= level_rising;
            end else begin
                dfr <= 1'b0;
            end
        end
    end

    // Nominal flow rate outputs (combinational) as per problem spec
    assign fr0 = (current_level <= 2'd2);              // fr0=1 for levels 0,1,2
    assign fr1 = (current_level == 2'd0) || (current_level == 2'd1);  // fr1=1 for LOW and MEDIUM_LOW
    assign fr2 = (current_level == 2'd0);               // fr2=1 only for LOW

endmodule