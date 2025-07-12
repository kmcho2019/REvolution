module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    // Water levels encoding
    // 0 = below s[0]       (no sensors asserted)
    // 1 = between s[0] and s[1] (s[0] only)
    // 2 = between s[1] and s[2] (s[0] and s[1])
    // 3 = above s[2]       (s[0], s[1], s[2])
    typedef reg [1:0] level_t;

    // Decode sensor input to water level state
    function level_t decode_level(input [2:0] sensors);
        begin
            case(sensors)
                3'b000: decode_level = 2'd0; // below s[0]
                3'b001: decode_level = 2'd1; // between s[0] and s[1]
                3'b011: decode_level = 2'd2; // between s[1] and s[2]
                3'b111: decode_level = 2'd3; // above s[2]
                default: decode_level = 2'd0; // treat invalid as below s[0]
            endcase
        end
    endfunction

    reg [1:0] prev_level;

    wire [1:0] current_level = decode_level(s);

    // On reset, initialize previous level to below s[0]
    // On each clock, update prev_level only if the level changed
    always @(posedge clk) begin
        if (reset)
            prev_level <= 2'd0;
        else if (current_level != prev_level)
            prev_level <= current_level;
    end

    // Outputs based on current_level
    // Nominal flow valves:
    // level 3 (above s[2]): all valves closed (0)
    // level 2: fr0=1, fr1=0, fr2=0
    // level 1: fr0=1, fr1=1, fr2=0
    // level 0: fr0=1, fr1=1, fr2=1
    wire fr0_val = (current_level != 2'd3);
    wire fr1_val = (current_level == 2'd0) || (current_level == 2'd1);
    wire fr2_val = (current_level == 2'd0);

    // Supplemental flow valve dfr: set if water level rose compared to prev_level
    wire dfr_val = (current_level > prev_level);

    // On reset, outputs are maximum flow (all nominal valves and supplemental open)
    assign fr0 = reset ? 1'b1 : fr0_val;
    assign fr1 = reset ? 1'b1 : fr1_val;
    assign fr2 = reset ? 1'b1 : fr2_val;
    assign dfr = reset ? 1'b1 : dfr_val;

endmodule