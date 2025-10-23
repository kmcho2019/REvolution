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

    // Function to decode sensors into water level state
    function [1:0] sensor_to_level;
        input [2:0] sens;
        begin
            casez(sens)
                3'b111: sensor_to_level = 2'd3; // Above s[2]
                3'b11?:  sensor_to_level = 2'd2; // Between s[2] and s[1] (s[2]=0,s[1]=1 or s[2]=1,s[1]=1, but s[0] ignored)
                3'b1?0:  sensor_to_level = 2'd1; // Between s[1] and s[0] (s[1]=1,s[0]=0)
                3'b0??:  sensor_to_level = 2'd0; // Below s[0] (s[0]=0)
                default: sensor_to_level = 2'd0; // default to Below s[0]
            endcase
        end
    endfunction

    // Synchronous process for levels and outputs
    always @(posedge clk) begin
        if (reset) begin
            curr_level <= 2'd0;  // Below s[0]
            prev_level <= 2'd0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            curr_level <= sensor_to_level(s);
            prev_level <= curr_level;

            // Set nominal flow outputs based on current water level
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

            // dfr asserted if water level rising compared to previous
            if (curr_level > prev_level)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule