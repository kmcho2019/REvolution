module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

// Water level encoding
localparam [1:0]
    BELOW_S0      = 2'd0,
    BETWEEN_S1_S0 = 2'd1,
    BETWEEN_S2_S1 = 2'd2,
    ABOVE_S2      = 2'd3;

// Function to decode the exact water level from sensor inputs
function [1:0] decode_level(input [2:0] s_in);
begin
    case (s_in)
        3'b111: decode_level = ABOVE_S2;       // Above s[2]
        3'b011: decode_level = BETWEEN_S2_S1;  // Between s[2] and s[1]
        3'b001: decode_level = BETWEEN_S1_S0;  // Between s[1] and s[0]
        3'b000: decode_level = BELOW_S0;       // Below s[0]
        default: decode_level = BELOW_S0;       // Treat other cases as BELOW_S0
    endcase
end
endfunction

// Registers to hold previous and current levels
reg [1:0] prev_level;
reg [1:0] curr_level;

wire [1:0] new_level = decode_level(s);
reg        level_increased;

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset: initialize to BELOW_S0 and all flows asserted
        prev_level     <= BELOW_S0;
        curr_level     <= BELOW_S0;
        level_increased <= 1'b0;

        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Compare new_level with prev_level BEFORE updating the registers
        level_increased <= (new_level > curr_level);

        // Update previous level to old current_level
        prev_level <= curr_level;

        // Update current level to newly decoded level
        curr_level <= new_level;

        // Drive outputs based on the decoded current level and level_increased
        case (new_level)
            ABOVE_S2: begin
                // Flow rate zero: all valves off
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            BETWEEN_S2_S1: begin
                // Nominal flow fr0 only
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            BETWEEN_S1_S0: begin
                // Nominal flow fr0 and fr1
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            BELOW_S0: begin
                // Maximum flow fr0, fr1, fr2
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
            default: begin
                // Safe default (treat as BELOW_S0)
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= level_increased ? 1'b1 : 1'b0;
            end
        endcase
    end
end

endmodule