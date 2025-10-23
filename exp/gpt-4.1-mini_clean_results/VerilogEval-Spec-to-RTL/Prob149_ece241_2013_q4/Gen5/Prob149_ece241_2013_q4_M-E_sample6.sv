module TopModule (
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output        dfr
);

// State encoding for water levels
typedef enum reg [1:0] {
    BELOW_S0      = 2'd0,
    BETWEEN_S1_S0 = 2'd1,
    BETWEEN_S2_S1 = 2'd2,
    ABOVE_S2      = 2'd3
} level_t;

reg [1:0] current_state, previous_state;

// Decode sensor input to a level state
function level_t decode_level(input [2:0] sens);
begin
    // Determine level based on sensor bits pattern:
    // Above s2: s = 3'b111
    // Between s2 and s1: s = 3'b011 (s[2]=0, s[1]=1, s[0]=1)
    // Between s1 and s0: s = 3'b001 (s[2]=0, s[1]=0, s[0]=1)
    // Below s0: s = 3'b000
    // All other patterns treated as BELOW_S0 to be conservative.
    case (sens)
        3'b111: decode_level = ABOVE_S2;
        3'b011: decode_level = BETWEEN_S2_S1;
        3'b001: decode_level = BETWEEN_S1_S0;
        3'b000: decode_level = BELOW_S0;
        default: decode_level = BELOW_S0;
    endcase
end
endfunction

// Update current_state and previous_state registers on clock
always @(posedge clk) begin
    if (reset) begin
        current_state  <= BELOW_S0;
        previous_state <= BELOW_S0;
    end else begin
        previous_state <= current_state;
        current_state  <= decode_level(s);
    end
end

// Check if water level increased: current_state > previous_state
wire level_increased = (current_state > previous_state);

// Combinational outputs driven by current_state and level_increased
assign fr2 = (current_state == BELOW_S0) ? 1'b1 : 1'b0;
assign fr1 = (current_state <= BETWEEN_S1_S0) ? 1'b1 : 1'b0;
assign fr0 = (current_state != ABOVE_S2) ? 1'b1 : 1'b0;

// dfr asserts if water level increased and flow is not zero (not ABOVE_S2)
assign dfr = (level_increased && (current_state != ABOVE_S2)) ? 1'b1 : 1'b0;

endmodule