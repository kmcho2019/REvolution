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
    // 0 = LOW (below s[0])            => no sensors asserted
    // 1 = MEDIUM_LOW (between s[1] and s[0]) => s[0] only
    // 2 = MEDIUM_HIGH (between s[2] and s[1])=> s[0] & s[1]
    // 3 = HIGH (above s[2])           => s[0], s[1], s[2]

    // Decode sensor input s into water level number (combinational)
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            // Exact matches per problem statement sensors asserted
            case (sensors)
                3'b000: decode_level = 2'd0; // None asserted => LOW
                3'b001: decode_level = 2'd1; // s[0] only => MEDIUM_LOW
                3'b011: decode_level = 2'd2; // s[0], s[1] => MEDIUM_HIGH
                3'b111: decode_level = 2'd3; // s[0], s[1], s[2] => HIGH
                default: 
                    // For any other combination, choose the highest level consistent:
                    // Check s[2] first
                    if (sensors[2]) decode_level = 2'd3;
                    else if (sensors[1]) decode_level = 2'd2;
                    else if (sensors[0]) decode_level = 2'd1;
                    else decode_level = 2'd0;
            endcase
        end
    endfunction

    wire [1:0] sampled_level = decode_level(s);

    reg [1:0] current_level, prev_level, prev_prev_level;

    // On reset: all outputs asserted (fr0, fr1, fr2, dfr) => level LOW (0)
    // On clock edge: update levels if level changed
    // dfr = 1 if sampled_level > prev_level on level change, else 0
    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'd0;
            prev_level <= 2'd0;
            prev_prev_level <= 2'd0;
            dfr <= 1'b1; // all valves open on reset per spec
        end else if (sampled_level != current_level) begin
            // Shift levels forward
            prev_prev_level <= prev_level;
            prev_level <= current_level;
            current_level <= sampled_level;
            dfr <= (sampled_level > prev_level) ? 1'b1 : 1'b0;
        end else begin
            dfr <= 1'b0;
        end
    end

    // Nominal flow rate outputs combinationally per water level table:
    // Above s[2]: level == 3 => no nominal flows => fr0=fr1=fr2=0
    // Between s[2] and s[1]: level == 2 => fr0 =1, fr1=0, fr2=0
    // Between s[1] and s[0]: level == 1 => fr0=1, fr1=1, fr2=0
    // Below s[0]: level == 0 => fr0=1, fr1=1, fr2=1
    assign fr0 = (current_level <= 2'd2);                // fr0 asserted for 0,1,2
    assign fr1 = (current_level == 2'd0) || (current_level == 2'd1); // fr1 for 0 or 1
    assign fr2 = (current_level == 2'd0);                // fr2 only for 0 (lowest level)

endmodule