module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output       dfr
);

    reg [2:0] prev_s;

    // Function to assign a numeric water level based on sensor pattern per spec:
    // 0: below s[0] (no sensors)
    // 1: between s[1] and s[0] (s[0] only)
    // 2: between s[2] and s[1] (s[0] and s[1])
    // 3: above s[2] (all three sensors)
    // Other patterns treated as below s[0] (lowest level) for safety
    function [1:0] water_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b000: water_level = 2'd0; // below s[0]
                3'b001: water_level = 2'd1; // between s[1] and s[0]
                3'b011: water_level = 2'd2; // between s[2] and s[1]
                3'b111: water_level = 2'd3; // above s[2]
                default: water_level = 2'd0; // treat all others as below s[0]
            endcase
        end
    endfunction

    wire [1:0] curr_level = water_level(s);
    wire [1:0] prev_level = water_level(prev_s);

    // Track previous sensor input on clock edge or reset
    always @(posedge clk) begin
        if (reset)
            prev_s <= 3'b000; // reset to below s[0] condition
        else
            prev_s <= s;
    end

    // dfr asserted if current level is greater than previous level (water rising)
    assign dfr = (curr_level > prev_level);

    // Nominal flow valve outputs according to spec:
    // Above s[2] (all sensors): fr2=0, fr1=0, fr0=0
    // Between s[2] and s[1]: fr0=1, fr1=0, fr2=0
    // Between s[1] and s[0]: fr0=1, fr1=1, fr2=0
    // Below s[0]: fr0=1, fr1=1, fr2=1
    // Default to below s[0] for invalid patterns (all outputs asserted)
    assign {fr2, fr1, fr0} =
           (s == 3'b111) ? 3'b000 :
           (s == 3'b011) ? 3'b001 :
           (s == 3'b001) ? 3'b011 :
                           3'b111; // includes 3'b000 and all other patterns

endmodule