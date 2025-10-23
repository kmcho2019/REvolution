module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water level encoding
    localparam BELOW_S0      = 2'd0;
    localparam BETWEEN_S1_S0 = 2'd1;
    localparam BETWEEN_S2_S1 = 2'd2;
    localparam ABOVE_S2      = 2'd3;

    // Decode sensors combinationally to water level
    // Assuming sensors: s[2] highest, s[0] lowest
    wire [1:0] current_level = 
        (s == 3'b111) ? ABOVE_S2 :
        (s == 3'b011) ? BETWEEN_S2_S1 :
        (s == 3'b001) ? BETWEEN_S1_S0 :
        (s == 3'b000) ? BELOW_S0 :
        // Handle any other pattern conservatively:
        (s[0]) ? BETWEEN_S1_S0 :
        (s[1]) ? BETWEEN_S2_S1 :
        (s[2]) ? ABOVE_S2 :
        BELOW_S0;

    // Registers to hold previous sensor input and water level at last sensor change
    reg [2:0] prev_s;
    reg [1:0] prev_level;

    // On clock edge, update prev_s and prev_level when sensor input changes
    always @(posedge clk) begin
        if (reset) begin
            prev_s     <= 3'b000;
            prev_level <= BELOW_S0;
        end else begin
            if (s != prev_s) begin
                // Update previous level at sensor change to last current_level
                prev_level <= current_level;
                prev_s <= s;
            end
        end
    end

    // dfr is asserted if current_level > prev_level (water level rose compared to previous sensor change)
    assign dfr = (current_level > prev_level);

    // Nominal flow valve outputs combinationally from current_level
    assign {fr2, fr1, fr0} = 
        (current_level == BELOW_S0)      ? 3'b111 :
        (current_level == BETWEEN_S1_S0) ? 3'b011 :  // fr0=1, fr1=1, fr2=0 => fr2 fr1 fr0 = 0 1 1
        (current_level == BETWEEN_S2_S1) ? 3'b001 :  // fr0=1, fr1=0, fr2=0
        (current_level == ABOVE_S2)      ? 3'b000 :  // all zero
        3'b111; // default safe

endmodule