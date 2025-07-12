module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Enumerate levels for clarity
localparam LEVEL_BELOW    = 2'd0; // no sensors asserted
localparam LEVEL_BETWEEN1 = 2'd1; // s[0] asserted only
localparam LEVEL_BETWEEN2 = 2'd2; // s[0] and s[1] asserted
localparam LEVEL_ABOVE    = 2'd3; // s[0], s[1], s[2] asserted

// Function to determine water level from sensor input (combinational)
function [1:0] get_level(input [2:0] s_in);
    begin
        if (s_in == 3'b111)
            get_level = LEVEL_ABOVE;
        else if (s_in[0] && s_in[1] && !s_in[2])
            get_level = LEVEL_BETWEEN2;
        else if (s_in[0] && !s_in[1] && !s_in[2])
            get_level = LEVEL_BETWEEN1;
        else if (s_in == 3'b000)
            get_level = LEVEL_BELOW;
        else begin
            // Fallback for undefined sensor states:
            if (s_in[0]) begin
                if (s_in[1]) begin
                    if (s_in[2]) get_level = LEVEL_ABOVE; else get_level = LEVEL_BETWEEN2;
                end else get_level = LEVEL_BETWEEN1;
            end else get_level = LEVEL_BELOW;
        end
    end
endfunction

reg [1:0] prev_level;

wire [1:0] curr_level;
assign curr_level = get_level(s);

wire rising;
assign rising = (curr_level > prev_level);

always @(posedge clk) begin
    if (reset) begin
        // Reset to "Below s[0]" with all valves open (max flow)
        prev_level <= LEVEL_BELOW;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update previous water level for next comparison
        prev_level <= curr_level;

        // Drive nominal flow valves based on current level:
        case (curr_level)
            LEVEL_ABOVE: begin
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            LEVEL_BETWEEN2: begin
                fr0 <= 1'b1;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
            LEVEL_BETWEEN1: begin
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b0;
            end
            LEVEL_BELOW: begin
                fr0 <= 1'b1;
                fr1 <= 1'b1;
                fr2 <= 1'b1;
            end
            default: begin
                fr0 <= 1'b0;
                fr1 <= 1'b0;
                fr2 <= 1'b0;
            end
        endcase

        // Supplemental flow valve opened if water level is rising
        dfr <= rising ? 1'b1 : 1'b0;
    end
end

endmodule