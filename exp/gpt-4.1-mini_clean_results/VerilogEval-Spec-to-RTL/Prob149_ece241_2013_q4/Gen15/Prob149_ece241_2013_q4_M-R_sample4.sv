module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

    // Water levels encoding
    // 0 = BELOW (no sensors asserted)
    // 1 = LOW   (only s[0] asserted)
    // 2 = MID   (s[0] and s[1] asserted)
    // 3 = ABOVE (all s[0], s[1], s[2] asserted)

    reg [1:0] curr_level, prev_level;

    // Decode water level from sensors (highest priority first)
    wire [1:0] decoded_level = 
        (s[2] & s[1] & s[0]) ? 2'd3 :  // ABOVE
        (s[1] & s[0])        ? 2'd2 :  // MID
        (s[0])               ? 2'd1 :  // LOW
                               2'd0 ;   // BELOW

    wire level_changed = (decoded_level != curr_level);
    wire level_rising = level_changed && (decoded_level > curr_level);

    // Sequential logic: update prev_level and curr_level synchronously
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= 2'd0;  // BELOW
            prev_level <= 2'd0;  // BELOW
            dfr <= 1'b1;         // asserted on reset
        end else begin
            if (level_changed)
                prev_level <= curr_level;
            curr_level <= decoded_level;

            // dfr asserted only one cycle on rising level transition
            if (level_rising)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

    // Nominal flow outputs assigned combinationally from current level
    assign {fr2, fr1, fr0} = 
        (curr_level == 2'd3) ? 3'b000 : // ABOVE
        (curr_level == 2'd2) ? 3'b001 : // MID
        (curr_level == 2'd1) ? 3'b011 : // LOW
                              3'b111 ;  // BELOW

endmodule