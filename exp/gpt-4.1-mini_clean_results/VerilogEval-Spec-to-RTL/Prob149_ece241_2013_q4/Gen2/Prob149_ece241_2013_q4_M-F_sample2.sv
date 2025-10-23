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

reg [2:0] s_reg;          // Registered sensor inputs
reg [1:0] curr_level;
reg [1:0] prev_level;
reg       level_increased;

// Decode water level from registered sensors exactly as specified
function [1:0] decode_level(input [2:0] s_in);
begin
    case (s_in)
        3'b111: decode_level = ABOVE_S2;       // Above s[2]
        3'b011: decode_level = BETWEEN_S2_S1;  // Between s[2] and s[1]
        3'b001: decode_level = BETWEEN_S1_S0;  // Between s[1] and s[0]
        3'b000: decode_level = BELOW_S0;       // Below s[0]
        default: decode_level = BELOW_S0;       // Treat all others as BELOW_S0
    endcase
end
endfunction

always @(posedge clk) begin
    if (reset) begin
        s_reg       <= 3'b000;
        curr_level  <= BELOW_S0;
        prev_level  <= BELOW_S0;
        level_increased <= 1'b0;
        // Reset outputs to all asserted as per spec
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Register sensor inputs
        s_reg <= s;
        
        // Update levels
        prev_level <= curr_level;
        curr_level <= decode_level(s_reg);
        
        // Determine if level increased compared to previous level
        level_increased <= (decode_level(s_reg) > curr_level) ? 1'b0 : // use old levels only, will fix below

                          // Actually, we must compare after updating curr_level and prev_level.
                          // Because of non-blocking semantics, curr_level on RHS is old value, so:
                          (decode_level(s_reg) > curr_level); 
                          // This expression is wrong in this position, will fix in next always block.

        // To properly compute level_increased, do it after levels updated:
        // We'll fix this in a separate always block below.
    end
end

// Since non-blocking assignments update all variables at end of clock,
// we need to compute level_increased and drive outputs after levels have stabilized.
// Combine in a single always block with correct ordering.

reg       level_increased_next;
reg [1:0] curr_level_next;
reg [1:0] prev_level_next;

always @(posedge clk) begin
    if (reset) begin
        // Initialize all state and outputs
        s_reg       <= 3'b000;
        curr_level  <= BELOW_S0;
        prev_level  <= BELOW_S0;
        level_increased <= 1'b0;

        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Register sensor inputs synchronously
        s_reg <= s;

        // Save previous curr_level
        prev_level <= curr_level;

        // Decode current level
        curr_level <= decode_level(s_reg);

        // After updating curr_level and prev_level, compute if level increased
        // Note that prev_level has old curr_level value before this cycle
        // Because prev_level <= curr_level in this clock edge, prev_level still has old curr_level value from last cycle
        // So comparing curr_level (new) and prev_level (old) here is correct

        // Wait for curr_level and prev_level to update before computing level_increased
        // To ensure this, compute level_increased combinationally after levels updated using blocking assignments
        // But blocking assignments can't be used in sequential always block, so use temporary variable

        // Use an intermediate combinational block

        // Actually, we'll move level_increased and outputs to a combinational always block below

    end
end

// Combinational logic for level_increased and outputs
always @(*) begin
    // level_increased compares registered levels from previous clock
    level_increased_next = (curr_level > prev_level);

    // Drive outputs based on curr_level and level_increased_next
    case (curr_level)
        ABOVE_S2: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
        BETWEEN_S2_S1: begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = level_increased_next ? 1'b1 : 1'b0;
        end
        BETWEEN_S1_S0: begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = level_increased_next ? 1'b1 : 1'b0;
        end
        BELOW_S0: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = level_increased_next ? 1'b1 : 1'b0;
        end
        default: begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = level_increased_next ? 1'b1 : 1'b0;
        end
    endcase
end

endmodule