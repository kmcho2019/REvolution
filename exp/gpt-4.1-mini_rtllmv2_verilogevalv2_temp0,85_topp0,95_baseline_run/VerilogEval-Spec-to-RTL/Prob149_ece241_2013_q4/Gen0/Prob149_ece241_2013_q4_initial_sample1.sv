module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [2:0]  s,
    output reg         fr2,
    output reg         fr1,
    output reg         fr0,
    output reg         dfr
);

    // Encode water level as:
    // 3 = Above s[2]: all sensors asserted (s == 3'b111)
    // 2 = Between s[2] and s[1]: s[0] and s[1] asserted, s[2] deasserted (s == 3'b011)
    // 1 = Between s[1] and s[0]: only s[0] asserted (s == 3'b001)
    // 0 = Below s[0]: no sensors asserted (s == 3'b000)
    // For any other input, treat as closest matching level or default to 0.

    reg [1:0] current_level;
    reg [1:0] previous_level;

    // Function to decode sensor input to level
    function [1:0] decode_level(input [2:0] sensors);
        begin
            case (sensors)
                3'b111: decode_level = 2'd3;  // Above s[2]
                3'b011: decode_level = 2'd2;  // Between s[2] and s[1]
                3'b001: decode_level = 2'd1;  // Between s[1] and s[0]
                3'b000: decode_level = 2'd0;  // Below s[0]
                default: 
                  // If sensors have other combinations, assign level based on highest asserted sensor:
                  // If s[2] asserted -> level 3
                  // else if s[1] asserted -> level 2
                  // else if s[0] asserted -> level 1
                  // else level 0
                  if (sensors[2]) decode_level = 2'd3;
                  else if (sensors[1]) decode_level = 2'd2;
                  else if (sensors[0]) decode_level = 2'd1;
                  else decode_level = 2'd0;
            endcase
        end
    endfunction

    // On reset and each clock cycle update level and outputs
    always @(posedge clk) begin
        if (reset) begin
            // Reset to below s[0] level with all flow outputs asserted
            current_level <= 2'd0;
            previous_level <= 2'd0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update levels
            previous_level <= current_level;
            current_level <= decode_level(s);

            // Determine nominal flow outputs based on current level
            case (current_level)
                2'd3: begin // Above s[2]: no flow outputs asserted
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd2: begin // Between s[2] and s[1]: fr0 asserted
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd1: begin // Between s[1] and s[0]: fr0, fr1 asserted
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                2'd0: begin // Below s[0]: fr0, fr1, fr2 asserted
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

            // Assert dfr if current level > previous level (water level rising)
            if (current_level > previous_level)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule