module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Define water levels for clarity
    localparam LEVEL_BELOW  = 2'd0; // No sensors asserted
    localparam LEVEL_S0     = 2'd1; // Only s[0] asserted
    localparam LEVEL_S1_S0  = 2'd2; // s[0] and s[1] asserted
    localparam LEVEL_ABOVE  = 2'd3; // All sensors asserted s[0],s[1],s[2]

    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Combinational function to decode sensor input to water level
    function [1:0] decode_level;
        input [2:0] sensors;
        begin
            // Prioritize highest valid pattern from problem description
            case (sensors)
                3'b111: decode_level = LEVEL_ABOVE;
                3'b011: decode_level = LEVEL_S1_S0;
                3'b001: decode_level = LEVEL_S0;
                default: decode_level = LEVEL_BELOW;
            endcase
        end
    endfunction

    wire [1:0] decoded_level = decode_level(s);

    // Sequential logic to update current and previous water levels and dfr
    always @(posedge clk) begin
        if (reset) begin
            // Reset: water level low for a long time (no sensors asserted), all flows asserted
            current_level <= LEVEL_BELOW;
            prev_level    <= LEVEL_BELOW;
            dfr           <= 1'b1;
            fr0           <= 1'b1;
            fr1           <= 1'b1;
            fr2           <= 1'b1;
        end else begin
            prev_level    <= current_level;
            current_level <= decoded_level;

            // Update nominal flow outputs combinationally based on the new current level
            case (decoded_level)
                LEVEL_ABOVE: begin
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                LEVEL_S1_S0: begin
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                LEVEL_S0: begin
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
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Supplemental flow valve dfr asserted if water level has risen compared to previous
            if (decoded_level > prev_level)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule