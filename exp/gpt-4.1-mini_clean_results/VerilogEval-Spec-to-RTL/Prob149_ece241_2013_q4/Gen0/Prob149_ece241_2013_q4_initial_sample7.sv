module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Encode water level states for easier comparison:
    // BELOW = 0: no sensors asserted
    // BETWEEN_10 = 1: s[0]=1 only
    // BETWEEN_21 = 2: s[1]=1 (and s[2]=0)
    // ABOVE = 3: s[2]=1
    reg [1:0] current_level;
    reg [1:0] prev_level;

    // Function to determine state from sensor input
    function [1:0] get_level(input [2:0] sensors);
        begin
            if(sensors[2])
                get_level = 3; // ABOVE
            else if(sensors[1])
                get_level = 2; // BETWEEN s[2] and s[1]
            else if(sensors[0])
                get_level = 1; // BETWEEN s[1] and s[0]
            else
                get_level = 0; // BELOW
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to BELOW state with all outputs asserted
            current_level <= 0;
            prev_level <= 0;
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Update levels
            current_level <= get_level(s);
            prev_level <= current_level;

            // Set nominal flow valves according to current level
            case (current_level)
                3: begin
                    // Above s[2]
                    fr2 <= 0;
                    fr1 <= 0;
                    fr0 <= 0;
                end
                2: begin
                    // Between s[2] and s[1]
                    fr2 <= 0;
                    fr1 <= 0;
                    fr0 <= 1;
                end
                1: begin
                    // Between s[1] and s[0]
                    fr2 <= 0;
                    fr1 <= 1;
                    fr0 <= 1;
                end
                0: begin
                    // Below s[0]
                    fr2 <= 1;
                    fr1 <= 1;
                    fr0 <= 1;
                end
                default: begin
                    fr2 <= 0;
                    fr1 <= 0;
                    fr0 <= 0;
                end
            endcase

            // Supplemental valve dfr logic:
            // If level increased since previous sensor change (i.e. current_level > prev_level), open dfr
            // Otherwise, close dfr
            if (current_level > prev_level)
                dfr <= 1'b1;
            else
                dfr <= 1'b0;
        end
    end

endmodule