module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water level states
    localparam BELOW_S0      = 2'd0; // no sensors asserted
    localparam BETWEEN_S1_S0 = 2'd1; // s[0] only
    localparam BETWEEN_S2_S1 = 2'd2; // s[0] & s[1]
    localparam ABOVE_S2      = 2'd3; // s[0], s[1], s[2]

    // Decode sensor input into stable water level state
    function [1:0] decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = ABOVE_S2;
                3'b011: decode_level = BETWEEN_S2_S1;
                3'b001: decode_level = BETWEEN_S1_S0;
                3'b000: decode_level = BELOW_S0;
                3'b010: decode_level = BETWEEN_S1_S0;  // s[1] only → treat as between s1 and s0
                3'b100: decode_level = BELOW_S0;       // s[2] only → treat as below s0 (fault)
                3'b101: decode_level = BETWEEN_S1_S0;  // s[0], s[2] → treat as between s1 and s0
                3'b110: decode_level = BETWEEN_S2_S1;  // s[1], s[2]
                default: decode_level = BELOW_S0;
            endcase
        end
    endfunction

    reg [1:0] level_curr, level_prev;

    always @(posedge clk) begin
        if (reset) begin
            level_curr <= BELOW_S0;
            level_prev <= BELOW_S0;
            dfr        <= 1'b1;  // all outputs asserted on reset per spec
        end else begin
            level_prev <= level_curr;
            level_curr <= decode_level(s);
            // Assert dfr if current level > previous level (water rising)
            dfr <= (level_curr > level_prev);
        end
    end

    // Nominal flow valve outputs combinationally derived from current water level
    // Above s[2]: no nominal valves open
    // Between s[2] and s[1]: fr0 only
    // Between s[1] and s[0]: fr0 and fr1
    // Below s[0]: fr0, fr1, fr2
    assign fr0 = (level_curr != ABOVE_S2);
    assign fr1 = (level_curr == BETWEEN_S1_S0) || (level_curr == BELOW_S0);
    assign fr2 = (level_curr == BELOW_S0);

endmodule