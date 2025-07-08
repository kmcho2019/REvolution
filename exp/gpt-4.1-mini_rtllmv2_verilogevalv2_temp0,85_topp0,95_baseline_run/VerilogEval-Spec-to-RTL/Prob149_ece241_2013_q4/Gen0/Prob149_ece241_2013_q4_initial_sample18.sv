module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level states encoding
    // 0 = Below s[0] (no sensors)
    // 1 = Between s[1] and s[0] (only s[0])
    // 2 = Between s[2] and s[1] (s[0] and s[1])
    // 3 = Above s[2] (all three sensors)

    reg [1:0] current_level, prev_level;

    // Function to decode sensors to water level
    function [1:0] decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = 2'd3; // Above s[2]
                3'b011: decode_level = 2'd2; // Between s[2] and s[1]
                3'b001: decode_level = 2'd1; // Between s[1] and s[0]
                3'b000: decode_level = 2'd0; // Below s[0]
                default: begin
                    // For any other combination, interpret according to the highest asserted sensor.
                    // We will prioritize highest sensor asserted:
                    if (sensors[2]) decode_level = 2'd3;
                    else if (sensors[1]) decode_level = 2'd2;
                    else if (sensors[0]) decode_level = 2'd1;
                    else decode_level = 2'd0;
                end
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to below s[0]: no sensors asserted, all outputs asserted
            current_level <= 2'd0;
            prev_level <= 2'd0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Decode current water level from sensors
            current_level <= decode_level(s);

            // Update prev_level only if level changes
            if (decode_level(s) != current_level) begin
                prev_level <= current_level;
            end

            // Determine outputs according to current level
            case (current_level)
                2'd3: begin // Above s[2]
                    fr0 <= 0;
                    fr1 <= 0;
                    fr2 <= 0;
                    dfr <= 0; // no supplemental flow when above s[2]
                end
                2'd2: begin // Between s[2] and s[1]
                    fr0 <= 1;
                    fr1 <= 0;
                    fr2 <= 0;
                    // supplemental flow if rising (prev_level < current_level)
                    dfr <= (prev_level < current_level) ? 1'b1 : 1'b0;
                end
                2'd1: begin // Between s[1] and s[0]
                    fr0 <= 1;
                    fr1 <= 1;
                    fr2 <= 0;
                    dfr <= (prev_level < current_level) ? 1'b1 : 1'b0;
                end
                2'd0: begin // Below s[0]
                    fr0 <= 1;
                    fr1 <= 1;
                    fr2 <= 1;
                    dfr <= (prev_level < current_level) ? 1'b1 : 1'b0;
                end
                default: begin
                    // default safe outputs if an undefined state occurs
                    fr0 <= 1;
                    fr1 <= 1;
                    fr2 <= 1;
                    dfr <= 0;
                end
            endcase

            // Update prev_level on sensor change after outputs are set
            if (decode_level(s) != current_level) begin
                prev_level <= current_level;
            end
        end
    end

endmodule