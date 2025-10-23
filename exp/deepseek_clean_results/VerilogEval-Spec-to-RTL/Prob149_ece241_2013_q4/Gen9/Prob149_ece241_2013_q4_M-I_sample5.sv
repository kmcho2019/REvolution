module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;  // Previous sensor state
    reg [1:0] state;   // Current water level state

    // State encoding:
    // 00 - Below s[0] (no sensors)
    // 01 - Between s[0] and s[1] (only s[0])
    // 10 - Between s[1] and s[2] (s[0] and s[1])
    // 11 - Above s[2] (all sensors)

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            prev_s <= 3'b000;
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            prev_s <= s;
            
            // State transition logic (priority encoded)
            casez (s)
                3'b??1: state <= 2'b11;    // Any sensor high -> above s[2]
                3'b?11: state <= 2'b11;    // s[1] and s[2] high -> above s[2]
                3'b011: state <= 2'b10;     // s[0] and s[1] high -> between s[1]-s[2]
                3'b001: state <= 2'b01;     // Only s[0] high -> between s[0]-s[1]
                default: state <= 2'b00;    // No sensors -> below s[0]
            endcase

            // Output logic
            fr0 <= (state != 2'b11);        // On unless above s[2]
            fr1 <= (state == 2'b00) || (state == 2'b01); // On when below s[1]
            fr2 <= (state == 2'b00);        // On only when below s[0]
            
            // Detect water level increase (any sensor newly asserted)
            dfr <= ((s[0] & ~prev_s[0]) | (s[1] & ~prev_s[1]) | (s[2] & ~prev_s[2]));
        end
    end

endmodule