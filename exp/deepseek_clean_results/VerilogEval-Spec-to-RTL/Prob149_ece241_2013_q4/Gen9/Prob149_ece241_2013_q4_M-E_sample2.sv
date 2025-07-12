module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Current level detection (0=below s0, 1=above s0, 2=above s1, 3=above s2)
    wire [1:0] current_level;
    assign current_level = s[2] ? 2'b11 : 
                         s[1] ? 2'b10 : 
                         s[0] ? 2'b01 : 2'b00;

    // Previous level register
    reg [1:0] prev_level;

    // Flow control logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset condition: all outputs high
            {fr2, fr1, fr0, dfr} <= 4'b1111;
            prev_level <= 2'b00; // Assume lowest level after reset
        end else begin
            // Update previous level
            prev_level <= current_level;

            // Base flow rate outputs
            fr0 <= (current_level < 2'b11); // Active when not above s2
            fr1 <= (current_level < 2'b10); // Active when below s1
            fr2 <= (current_level == 2'b00); // Active only when below s0

            // Supplemental flow (rising level detection)
            dfr <= (current_level > prev_level);
        end
    end

endmodule