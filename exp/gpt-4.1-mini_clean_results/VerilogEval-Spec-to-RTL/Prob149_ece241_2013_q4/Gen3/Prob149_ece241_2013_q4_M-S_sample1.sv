module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output       fr2,
    output       fr1,
    output       fr0,
    output reg   dfr
);

// Define water levels
localparam BELOW_S0       = 2'd0;
localparam BETWEEN_S1_S0  = 2'd1;
localparam BETWEEN_S2_S1  = 2'd2;
localparam ABOVE_S2       = 2'd3;

// Decode sensors to water level
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

reg [1:0] prev_level;
reg [1:0] curr_level;

always @(posedge clk) begin
    if (reset) begin
        prev_level <= BELOW_S0;
        curr_level <= BELOW_S0;
        dfr <= 1'b1; // Supplemental flow valve open on reset
    end else begin
        // Decode current sensors
        reg [1:0] new_level;
        new_level = decode_level(s);

        if (new_level != curr_level) begin
            // Level changed: update previous and current levels
            prev_level <= curr_level;
            curr_level <= new_level;
            dfr <= (new_level > curr_level) ? 1'b1 : 1'b0; // dfr asserted if water level rose
        end else begin
            dfr <= 1'b0; // no change, no supplemental valve
        end
    end
end

// Nominal flow valves from current level
assign fr2 = (curr_level == BELOW_S0) ? 1'b1 : 1'b0;
assign fr1 = (curr_level <= BETWEEN_S1_S0) ? 1'b1 : 1'b0;
assign fr0 = (curr_level != ABOVE_S2) ? 1'b1 : 1'b0;

endmodule