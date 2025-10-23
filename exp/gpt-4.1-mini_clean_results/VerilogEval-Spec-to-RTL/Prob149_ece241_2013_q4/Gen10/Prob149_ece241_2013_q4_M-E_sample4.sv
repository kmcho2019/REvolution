module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Define water level states
    // 2'b00: Below s[0] (no sensors asserted)
    // 2'b01: Between s[1] and s[0] (only s[0] asserted)
    // 2'b10: Between s[2] and s[1] (s[0] and s[1] asserted)
    // 2'b11: Above s[2] (all three sensors asserted)
    // Any other pattern treated as below s[0] for safety
    
    localparam BELOW_S0      = 2'b00;
    localparam BETWEEN_S1_S0 = 2'b01;
    localparam BETWEEN_S2_S1 = 2'b10;
    localparam ABOVE_S2      = 2'b11;

    reg [1:0] prev_level;
    reg [1:0] curr_level;

    // Decode sensor pattern combinationally into curr_level
    always @(*) begin
        case (s)
            3'b000: curr_level = BELOW_S0;        // no sensors asserted
            3'b001: curr_level = BETWEEN_S1_S0;  // only s[0]
            3'b011: curr_level = BETWEEN_S2_S1;  // s[0] and s[1]
            3'b111: curr_level = ABOVE_S2;        // all three sensors
            default: begin
                // Check for 3'b110 as valid "Between s2 and s1" (s[1] and s[2])
                // Problem states sensors at 5 inch intervals vertically:
                // The problem states "Between s[2] and s[1]" is s[0], s[1] asserted.
                // Thus 3'b011 only, not 3'b110.
                // So 3'b110 or 3'b101, 3'b100 etc. treated as BELOW_S0 for safety.
                curr_level = BELOW_S0;
            end
        endcase
    end

    // On every clock, update prev_level and dfr, with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= BELOW_S0;
            dfr <= 1'b1; // supplemental flow open on reset (assumed long low level)
        end else begin
            dfr <= (curr_level > prev_level);
            prev_level <= curr_level;
        end
    end

    // Nominal flow valves combinational per current level:
    // Below s0: fr0=1, fr1=1, fr2=1
    // Between s1 and s0: fr0=1, fr1=1, fr2=0
    // Between s2 and s1: fr0=1, fr1=0, fr2=0
    // Above s2: fr0=0, fr1=0, fr2=0

    assign fr0 = (curr_level != ABOVE_S2);
    assign fr1 = (curr_level == BELOW_S0) || (curr_level == BETWEEN_S1_S0);
    assign fr2 = (curr_level == BELOW_S0);

endmodule