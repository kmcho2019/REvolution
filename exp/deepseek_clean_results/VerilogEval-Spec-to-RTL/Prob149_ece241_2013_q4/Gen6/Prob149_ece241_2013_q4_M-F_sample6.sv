module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Track previous sensor state
    reg [2:0] prev_s;
    
    // Current level encoding
    wire [1:0] current_level;
    assign current_level = s[2] ? 2'd3 :       // above s[2]
                          s[1] ? 2'd2 :       // between s[2]-s[1]
                          s[0] ? 2'd1 :       // between s[1]-s[0]
                                 2'd0;        // below s[0]
    
    // Previous level encoding
    wire [1:0] prev_level;
    assign prev_level = prev_s[2] ? 2'd3 :    // above s[2]
                        prev_s[1] ? 2'd2 :   // between s[2]-s[1]
                        prev_s[0] ? 2'd1 :    // between s[1]-s[0]
                                   2'd0;      // below s[0]

    always @(posedge clk) begin
        if (reset) begin
            // Reset to maximum flow state (all outputs high)
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
            prev_s <= 3'b000;
        end else begin
            // Store previous sensor state
            prev_s <= s;

            // Set flow rate outputs based on current level
            fr2 <= (current_level == 2'd0);  // below s[0]
            fr1 <= (current_level <= 2'd1);   // below s[0] or between s[1]-s[0]
            fr0 <= (current_level <= 2'd2);   // below s[0] or between s[1]-s[0] or between s[2]-s[1]

            // Determine if water level was rising (previous < current) and not at max level
            dfr <= (prev_level < current_level) && (current_level != 2'd3);
        end
    end

endmodule