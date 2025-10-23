module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output reg dfr
);

// Water levels encoding (2 bits)
localparam BELOW_S0       = 2'd0;
localparam BETWEEN_S1_S0  = 2'd1;
localparam BETWEEN_S2_S1  = 2'd2;
localparam ABOVE_S2       = 2'd3;

// Decode sensor pattern to water level.
// Maps various sensor combinations to discrete water level states.
function [1:0] decode_level(input [2:0] sensors);
    begin
        case (sensors)
            3'b000: decode_level = BELOW_S0;
            3'b001: decode_level = BETWEEN_S1_S0;
            3'b011: decode_level = BETWEEN_S2_S1;
            3'b111: decode_level = ABOVE_S2;
            3'b010: decode_level = BETWEEN_S2_S1;
            3'b100: decode_level = ABOVE_S2;
            3'b101: decode_level = ABOVE_S2;
            3'b110: decode_level = ABOVE_S2;
            default: decode_level = BELOW_S0;
        endcase
    end
endfunction

// Registers to hold sensor state and decoded levels
reg [2:0] prev_sensors;
reg [1:0] curr_level;
reg [1:0] prev_level_before_change;

always @(posedge clk) begin
    if (reset) begin
        // Initialize to no sensors asserted (below s0),
        // maximum nominal flow (all fr asserted),
        // and supplemental flow asserted (dfr = 1).
        prev_sensors <= 3'b000;
        curr_level <= BELOW_S0;
        prev_level_before_change <= BELOW_S0;
        dfr <= 1'b1;
    end else begin
        if (s != prev_sensors) begin
            // On sensor pattern change:
            // Store previous current_level in prev_level_before_change
            prev_level_before_change <= curr_level;
            // Update current level with new sensor reading
            curr_level <= decode_level(s);
            // Update previous sensors
            prev_sensors <= s;
            // dfr is asserted if water level rose compared to previous level before last change
            dfr <= (decode_level(s) > curr_level) ? 1'b1 : 1'b0;
        end else begin
            // No change in sensors => dfr deasserted
            dfr <= 1'b0;
        end
    end
end

// Nominal flow valve outputs (combinational) based on current level
assign fr2 = (curr_level == BELOW_S0) ? 1'b1 : 1'b0;
assign fr1 = (curr_level <= BETWEEN_S1_S0) ? 1'b1 : 1'b0;
assign fr0 = (curr_level != ABOVE_S2) ? 1'b1 : 1'b0;

endmodule