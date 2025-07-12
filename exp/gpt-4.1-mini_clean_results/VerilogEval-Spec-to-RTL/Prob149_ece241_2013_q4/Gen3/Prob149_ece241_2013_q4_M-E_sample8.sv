module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output reg dfr
);

// Water level definitions
localparam BELOW_S0      = 2'd0;
localparam BETWEEN_S1_S0 = 2'd1;
localparam BETWEEN_S2_S1 = 2'd2;
localparam ABOVE_S2      = 2'd3;

// Decode sensor input s into a water level state
function [1:0] decode_level(input [2:0] sensors);
    begin
        case (sensors)
            3'b111: decode_level = ABOVE_S2;      // all sensors asserted
            3'b011: decode_level = BETWEEN_S2_S1; // s0 and s1 asserted
            3'b001: decode_level = BETWEEN_S1_S0; // only s0 asserted
            3'b000: decode_level = BELOW_S0;      // no sensors asserted
            // Treat intermediate patterns as closest water level:
            3'b010: decode_level = BETWEEN_S2_S1; // s1 only -> same as between s2 and s1
            3'b100: decode_level = ABOVE_S2;      // s2 only -> above s2
            3'b101: decode_level = ABOVE_S2;      // s2 and s0
            3'b110: decode_level = ABOVE_S2;      // s2 and s1
            default: decode_level = BELOW_S0;
        endcase
    end
endfunction

// Registers holding current and previous water levels
reg [1:0] curr_level, prev_level;

always @(posedge clk) begin
    if (reset) begin
        // On reset: assume lowest water level and max flow valves on
        curr_level <= BELOW_S0;
        prev_level <= BELOW_S0;
        dfr <= 1'b1;  // Supplemental valve open initially
    end else begin
        curr_level <= decode_level(s);

        // dfr is asserted if current water level rose compared to previous level
        if (decode_level(s) > prev_level)
            dfr <= 1'b1;
        else
            dfr <= 1'b0;

        prev_level <= curr_level;
    end
end

// Nominal flow valves (combinational) based on current water level
assign fr2 = (curr_level == BELOW_S0) ? 1'b1 : 1'b0;
assign fr1 = (curr_level <= BETWEEN_S1_S0) ? 1'b1 : 1'b0;
assign fr0 = (curr_level != ABOVE_S2) ? 1'b1 : 1'b0;

endmodule