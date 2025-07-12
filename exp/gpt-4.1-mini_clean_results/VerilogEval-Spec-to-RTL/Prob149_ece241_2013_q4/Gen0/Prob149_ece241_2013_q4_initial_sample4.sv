module TopModule(
    input  wire        clk,
    input  wire        reset,
    input  wire [2:0]  s,
    output reg         fr2,
    output reg         fr1,
    output reg         fr0,
    output reg         dfr
);

    // Internal register to hold previous water level
    reg [1:0] prev_level; // max 3, need 2 bits

    // Function to count number of asserted sensors in s
    function [1:0] count_sensors;
        input [2:0] s_in;
        begin
            count_sensors = s_in[0] + s_in[1] + s_in[2];
        end
    endfunction

    reg [1:0] curr_level;

    always @(posedge clk) begin
        if (reset) begin
            // On reset, water level assumed low for long time:
            // no sensors asserted (level 0), all flow outputs asserted
            prev_level <= 2'd0;
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            curr_level = count_sensors(s);

            // Determine nominal flow outputs based on current_level
            case (curr_level)
                2'd3: begin // above s[2]: all sensors asserted
                    fr0 <= 1'b0;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd2: begin // between s[2] and s[1]
                    fr0 <= 1'b1;
                    fr1 <= 1'b0;
                    fr2 <= 1'b0;
                end
                2'd1: begin // between s[1] and s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b0;
                end
                2'd0: begin // below s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
                default: begin
                    // Handle unexpected sensor patterns safely:
                    // treat as below s[0]
                    fr0 <= 1'b1;
                    fr1 <= 1'b1;
                    fr2 <= 1'b1;
                end
            endcase

            // Determine if water level has increased compared to previous level
            // If increased, open supplemental valve (dfr=1), else closed (0)
            if (curr_level > prev_level)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;

            // Update previous level
            prev_level <= curr_level;
        end
    end

endmodule