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
    localparam BETWEEN_S1_S0 = 2'd1; // s[0] only
    localparam BETWEEN_S2_S1 = 2'd2; // s[0] and s[1]
    localparam ABOVE_S2      = 2'd3; // s[0], s[1], s[2]

    // Decode sensor inputs into water level states
    // Robust decoding: 
    //   If s[2] asserted => ABOVE_S2
    //   Else if s[1] and s[0] asserted => BETWEEN_S2_S1
    //   Else if s[0] asserted => BETWEEN_S1_S0
    //   Else BELOW_S0
    function [1:0] decode_sensors;
        input [2:0] sensors;
        begin
            if (sensors[2])
                decode_sensors = ABOVE_S2;
            else if (sensors[1] && sensors[0])
                decode_sensors = BETWEEN_S2_S1;
            else if (sensors[0])
                decode_sensors = BETWEEN_S1_S0;
            else
                decode_sensors = BELOW_S0;
        end
    endfunction

    reg [1:0] stable_level, prev_level;

    wire [1:0] new_level = decode_sensors(s);

    always @(posedge clk) begin
        if (reset) begin
            stable_level <= BELOW_S0;
            prev_level <= BELOW_S0;
        end else begin
            if (new_level != stable_level) begin
                prev_level <= stable_level;
                stable_level <= new_level;
            end
            // else no change to levels
        end
    end

    // dfr asserted only when current stable level is strictly greater than previous stable level
    assign dfr = (stable_level > prev_level);

    // Nominal flow outputs depend on stable_level:
    // ABOVE_S2: no valves open
    // BETWEEN_S2_S1: fr0 only
    // BETWEEN_S1_S0: fr0 and fr1
    // BELOW_S0: fr0, fr1, fr2
    assign fr0 = (stable_level != ABOVE_S2);
    assign fr1 = (stable_level == BETWEEN_S1_S0) || (stable_level == BELOW_S0);
    assign fr2 = (stable_level == BELOW_S0);

endmodule