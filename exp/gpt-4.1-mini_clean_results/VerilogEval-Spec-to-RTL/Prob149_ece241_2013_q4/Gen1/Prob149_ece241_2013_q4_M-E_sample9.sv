module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

// Water level states encoded as 2-bit levels:
localparam LEVEL_0 = 2'd0; // Below s[0]
localparam LEVEL_1 = 2'd1; // Between s[1] and s[0]
localparam LEVEL_2 = 2'd2; // Between s[2] and s[1]
localparam LEVEL_3 = 2'd3; // Above s[2]

// Decode water level from sensor pattern s
// Only exact patterns per problem spec considered:
// s=111 => level 3, s=011 => level 2, s=001 => level 1, s=000 => level 0
// Other patterns treated as closest lower level conservatively
function [1:0] decode_level(input [2:0] sensors);
    begin
        case (sensors)
            3'b111: decode_level = LEVEL_3;
            3'b011: decode_level = LEVEL_2;
            3'b001: decode_level = LEVEL_1;
            3'b000: decode_level = LEVEL_0;
            // Approximate other inputs conservatively:
            3'b010: decode_level = LEVEL_1; // treat as between s[1] and s[0]
            3'b100: decode_level = LEVEL_0;
            3'b101: decode_level = LEVEL_0;
            3'b110: decode_level = LEVEL_2;
            default: decode_level = LEVEL_0;
        endcase
    end
endfunction

wire [1:0] current_level = decode_level(s);

reg [1:0] prev_level;       // level from last clock cycle
reg [1:0] prev_prev_level;  // level from two clock cycles ago

always @(posedge clk) begin
    if (reset) begin
        // On reset, initialize to lowest level and all outputs high (max flow)
        prev_prev_level <= LEVEL_0;
        prev_level <= LEVEL_0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Shift water level history
        prev_prev_level <= prev_level;
        prev_level <= current_level;

        // Determine nominal flow outputs from current_level
        // According to spec:
        // LEVEL_3: no flow valves open (fr2=fr1=fr0=0)
        // LEVEL_2: fr0 only
        // LEVEL_1: fr0 and fr1
        // LEVEL_0: fr0, fr1, fr2 all open
        case (current_level)
            LEVEL_3: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
            LEVEL_2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            LEVEL_1: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            LEVEL_0: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            default: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
        endcase

        // Supplemental flow valve (dfr):
        // Assert if current_level > prev_prev_level, meaning water level
        // has risen above the level two cycles ago (previous to last sensor change)
        if (current_level > prev_prev_level)
            dfr <= 1'b1;
        else
            dfr <= 1'b0;
    end
end

endmodule