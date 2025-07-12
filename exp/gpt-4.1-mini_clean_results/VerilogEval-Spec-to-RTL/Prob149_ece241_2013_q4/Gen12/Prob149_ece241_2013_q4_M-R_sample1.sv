module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding (2 bits)
    localparam BELOW_S0      = 2'd0; // no sensors asserted
    localparam BETWEEN_S1_S0 = 2'd1; // only s[0] asserted
    localparam BETWEEN_S2_S1 = 2'd2; // s[0] and s[1] asserted
    localparam ABOVE_S2      = 2'd3; // all sensors asserted (s[0], s[1], s[2])

    // Decode sensor inputs into water levels
    function [1:0] decode_sensors;
        input [2:0] sensors;
        begin
            case (sensors)
                3'b000: decode_sensors = BELOW_S0;
                3'b001: decode_sensors = BETWEEN_S1_S0;
                3'b011: decode_sensors = BETWEEN_S2_S1;
                3'b111: decode_sensors = ABOVE_S2;
                default: decode_sensors = BELOW_S0; // treat unknown as BELOW_S0
            endcase
        end
    endfunction

    wire [1:0] new_level = decode_sensors(s);

    reg [1:0] stable_level;
    reg [1:0] prev_level;

    // Update stable_level and prev_level on each clock when water level changes
    always @(posedge clk) begin
        if (reset) begin
            stable_level <= BELOW_S0;
            prev_level   <= BELOW_S0;
        end else if (new_level != stable_level) begin
            prev_level   <= stable_level;
            stable_level <= new_level;
        end
    end

    // dfr is combinational: 1 if water level rose, 0 otherwise
    assign dfr = (stable_level > prev_level) ? 1'b1 : 1'b0;

    // Nominal flow outputs combinationally decoded from stable_level
    assign fr0 = (stable_level != ABOVE_S2);
    assign fr1 = (stable_level == BETWEEN_S1_S0) || (stable_level == BELOW_S0);
    assign fr2 = (stable_level == BELOW_S0);

endmodule