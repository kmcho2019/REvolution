module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Define water levels as integer codes
    localparam BELOW = 2'd0; // No sensors asserted
    localparam LOW   = 2'd1; // Only s[0] asserted
    localparam MID   = 2'd2; // s[0] and s[1] asserted
    localparam HIGH  = 2'd3; // s[0], s[1], s[2] asserted

    reg [1:0] current_level, previous_level;

    // Decode sensor inputs to water level code
    // We consider only valid sensor patterns and assign levels accordingly
    // Any other patterns (e.g. s[1]=1 but s[0]=0) treated as BELOW for robustness
    wire s0 = s[0];
    wire s1 = s[1];
    wire s2 = s[2];

    wire valid_high = (s0 & s1 & s2);       // 3'b111
    wire valid_mid  = (s0 & s1 & ~s2);      // 3'b011
    wire valid_low  = (s0 & ~s1 & ~s2);     // 3'b001
    wire valid_below= (~s0 & ~s1 & ~s2);    // 3'b000

    wire [1:0] decoded_level =
          valid_high ? HIGH :
          valid_mid  ? MID  :
          valid_low  ? LOW  :
          valid_below? BELOW :
          BELOW; // For any other invalid patterns

    // Synchronous logic to store previous and current level
    always @(posedge clk) begin
        if (reset) begin
            current_level  <= BELOW;
            previous_level <= BELOW;
        end else begin
            previous_level <= current_level;
            current_level  <= decoded_level;
        end
    end

    // dfr is asserted when water level rises from previous to current
    assign dfr = (current_level > previous_level);

    // Assign nominal flow valves from current level per table:
    // HIGH   (3): 000 (no nominal flow)
    // MID    (2): 001 (fr0)
    // LOW    (1): 011 (fr1, fr0)
    // BELOW  (0): 111 (fr2, fr1, fr0)
    assign {fr2, fr1, fr0} =
        (current_level == HIGH) ? 3'b000 :
        (current_level == MID)  ? 3'b001 :
        (current_level == LOW)  ? 3'b011 :
                                 3'b111;

endmodule