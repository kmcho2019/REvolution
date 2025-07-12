module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Water level states encoding:
    // 2'd0 = Below s[0]
    // 2'd1 = Between s[1] and s[0]
    // 2'd2 = Between s[2] and s[1]
    // 2'd3 = Above s[2]

    reg [1:0] curr_level;
    reg [1:0] prev_level;

    // Decode sensor inputs exactly
    function [1:0] sensor_to_level;
        input [2:0] sens;
        begin
            case (sens)
                3'b111: sensor_to_level = 2'd3; // Above s[2]
                3'b110: sensor_to_level = 2'd2; // Between s[2] and s[1]
                3'b100: sensor_to_level = 2'd1; // Between s[1] and s[0]
                default: sensor_to_level = 2'd0; // Below s[0]
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            curr_level <= 2'd0;  // Below s[0]
            prev_level <= 2'd0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            prev_level <= curr_level;            // Hold last cycle's curr_level
            curr_level <= sensor_to_level(s);   // Update current level from inputs

            // Nominal flow outputs per current level
            case (curr_level)
                2'd3: begin // Above s[2]
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                end
                2'd2: begin // Between s[2] and s[1]
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                end
                2'd1: begin // Between s[1] and s[0]
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                2'd0: begin // Below s[0]
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
                default: begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                end
            endcase

            // Supplemental flow if water level is rising (curr_level > prev_level)
            dfr <= (curr_level > prev_level) ? 1'b1 : 1'b0;
        end
    end

endmodule