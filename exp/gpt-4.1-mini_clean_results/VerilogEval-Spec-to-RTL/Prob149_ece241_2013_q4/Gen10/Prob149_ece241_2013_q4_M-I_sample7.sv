module TopModule (
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Enumerated water levels (2 bits):
    // 2'd3: Above s[2] (s=111)
    // 2'd2: Between s[2] and s[1] (s=110)
    // 2'd1: Between s[1] and s[0] (s=100)
    // 2'd0: Below s[0] (all others)

    reg [1:0] curr_level;
    reg [1:0] prev_level;

    // Function to decode sensor input to water level
    function [1:0] sensor_to_level;
        input [2:0] sens;
        begin
            case (sens)
                3'b111: sensor_to_level = 2'd3; // Above s[2]
                3'b110: sensor_to_level = 2'd2; // Between s[2] and s[1]
                3'b100: sensor_to_level = 2'd1; // Between s[1] and s[0]
                default: sensor_to_level = 2'd0; // Below s[0] (includes 3'b000, others)
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
            prev_level <= curr_level;
            curr_level <= sensor_to_level(s);

            // Nominal flow outputs based on current level
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

            // Supplemental flow valve: open if water level is rising
            dfr <= (curr_level > prev_level) ? 1'b1 : 1'b0;
        end
    end

endmodule