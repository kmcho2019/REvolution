module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

// Water level encoding based on sensors:
// Level 3: Above s[2]  (s=111)
// Level 2: Between s[2] and s[1] (s=011)
// Level 1: Between s[1] and s[0] (s=001)
// Level 0: Below s[0]  (s=000)
// Other s values do not appear valid per spec, treat conservatively.

localparam LEVEL_0 = 2'd0; // Below s[0]
localparam LEVEL_1 = 2'd1; // Between s[1] and s[0]
localparam LEVEL_2 = 2'd2; // Between s[2] and s[1]
localparam LEVEL_3 = 2'd3; // Above s[2]

reg [1:0] previous_level;

function [1:0] decode_level(input [2:0] sensors);
    begin
        case (sensors)
            3'b111: decode_level = LEVEL_3;
            3'b011: decode_level = LEVEL_2;
            3'b001: decode_level = LEVEL_1;
            3'b000: decode_level = LEVEL_0;
            // Defensive defaults for unexpected sensor inputs:
            3'b010: decode_level = LEVEL_1; // treat as LEVEL_1 (closest)
            3'b100: decode_level = LEVEL_0; // treat as LEVEL_0
            3'b101: decode_level = LEVEL_0;
            3'b110: decode_level = LEVEL_2;
            default: decode_level = LEVEL_0;
        endcase
    end
endfunction

wire [1:0] current_level = decode_level(s);

// On reset, set previous_level = LEVEL_0, and all flow outputs = 1
always @(posedge clk) begin
    if (reset) begin
        previous_level <= LEVEL_0;
        // All flow valves open: fr2, fr1, fr0, dfr = 1
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update previous_level only if current level differs
        if (current_level != previous_level) begin
            previous_level <= current_level;
        end

        // Determine if water level rose compared to previous level
        // current_level > previous_level means water level went up
        if (current_level > previous_level)
            dfr <= 1'b1;
        else
            dfr <= 1'b0;

        // Set nominal flow outputs based on current_level
        case (current_level)
            LEVEL_3: begin
                // Above s[2] - all nominal flow valves closed
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
            LEVEL_2: begin
                // Between s[2] and s[1] - fr0 only
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            LEVEL_1: begin
                // Between s[1] and s[0] - fr0 and fr1
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            LEVEL_0: begin
                // Below s[0] - fr0, fr1, fr2 all on
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            default: begin
                // Defensive default to lowest level full flow
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
        endcase
    end
end

endmodule