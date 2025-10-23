module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Define water level encoding (2 bits sufficient)
    localparam BELOW_S0      = 2'd0; // no sensors asserted
    localparam BETWEEN_S1_S0 = 2'd1; // only s[0] asserted
    localparam BETWEEN_S2_S1 = 2'd2; // s[0] and s[1] asserted
    localparam ABOVE_S2      = 2'd3; // all sensors asserted (s[0], s[1], s[2])

    reg [1:0] curr_level, prev_level;

    // Decode sensor inputs into water levels
    // Only valid patterns are 000, 001, 011, 111, others treated as BELOW_S0
    function [1:0] decode_sensors;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: decode_sensors = BELOW_S0;
                3'b001: decode_sensors = BETWEEN_S1_S0;
                3'b011: decode_sensors = BETWEEN_S2_S1;
                3'b111: decode_sensors = ABOVE_S2;
                default: decode_sensors = BELOW_S0; // Treat undefined patterns as BELOW_S0
            endcase
        end
    endfunction

    wire [1:0] decoded_level = decode_sensors(s);

    // Nominal flow outputs purely combinational from curr_level
    // According to problem:
    // ABOVE_S2 (3'b111): no outputs asserted (flow rate zero)
    // BETWEEN_S2_S1 (3'b011): fr0 only
    // BETWEEN_S1_S0 (3'b001): fr0 and fr1
    // BELOW_S0  (3'b000): fr0, fr1 and fr2
    assign fr0 = (curr_level != ABOVE_S2);
    assign fr1 = (curr_level == BETWEEN_S1_S0) || (curr_level == BELOW_S0);
    assign fr2 = (curr_level == BELOW_S0);

    // Compare current level to previous level for rising water level
    wire level_rising = (curr_level > prev_level);

    // Sequential logic: register levels and dfr synchronously
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= BELOW_S0;
            prev_level <= BELOW_S0;
            dfr        <= 1'b1; // On reset, all outputs asserted (including dfr)
        end else begin
            prev_level <= curr_level;
            curr_level <= decoded_level;
            dfr        <= level_rising;
        end
    end

endmodule