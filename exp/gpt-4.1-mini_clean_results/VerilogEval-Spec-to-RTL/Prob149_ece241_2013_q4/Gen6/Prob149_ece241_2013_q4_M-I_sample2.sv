module TopModule (
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output        dfr
);

// Define water level states as integer 2-bit values for easy numeric comparison
// 0: BELOW_S0, 1: BETWEEN_S1_S0, 2: BETWEEN_S2_S1, 3: ABOVE_S2
reg [1:0] current_level, previous_level;

// Function to decode sensors into level
// Level is number of asserted sensors starting from s[0] upwards, capped to 3
// But we must distinguish correct states:
// According to problem sensors:
//
// s[2] s[1] s[0]
//   1    1    1  => level 3 (above s2)
//
// Between s2 and s1 means s[2]=0, s[1]=1, s[0]=1 => level 2
// Between s1 and s0 means s[2]=0, s[1]=0, s[0]=1 => level 1
// Below s0 means all zero => level 0
//
// For more robust detection, interpret as number of sensors asserted starting from bottom:
// But must ensure consistency with the problem: Above s2 only if all sensors asserted
// So we can implement decode_level as:
function [1:0] decode_level(input [2:0] sens);
begin
    case (sens)
        3'b111: decode_level = 2'd3; // Above s2
        3'b011: decode_level = 2'd2; // Between s2 and s1
        3'b001: decode_level = 2'd1; // Between s1 and s0
        3'b000: decode_level = 2'd0; // Below s0
        default: begin
            // For other input patterns, deduce level by counting asserted sensors and their order:
            // To avoid ambiguity, assign level as max contiguous asserted sensors from bottom:
            // Priority order:
            if (sens[0] == 1'b1) begin
                if (sens[1] == 1'b1) begin
                    if (sens[2] == 1'b1) decode_level = 2'd3;
                    else decode_level = 2'd2;
                end else decode_level = 2'd1;
            end else decode_level = 2'd0;
        end
    endcase
end
endfunction

// Sequential update of levels
always @(posedge clk) begin
    if (reset) begin
        current_level  <= 2'd0; // BELOW_S0
        previous_level <= 2'd0;
    end else begin
        previous_level <= current_level;
        current_level  <= decode_level(s);
    end
end

wire level_increased = (current_level > previous_level);

// Output logic

// fr0: asserted if level != ABOVE_S2 (3)
assign fr0 = (current_level != 2'd3) ? 1'b1 : 1'b0;

// fr1: asserted if level <= BETWEEN_S1_S0 (1) or BELOW_S0 (0)
assign fr1 = (current_level <= 2'd1) ? 1'b1 : 1'b0;

// fr2: asserted if BELOW_S0 (0)
assign fr2 = (current_level == 2'd0) ? 1'b1 : 1'b0;

// dfr: asserted if level_increased and level != ABOVE_S2, or on reset (lowest level with supplemental flow)
assign dfr = (level_increased && (current_level != 2'd3)) ? 1'b1 : 
             (reset ? 1'b1 : 1'b0);

endmodule