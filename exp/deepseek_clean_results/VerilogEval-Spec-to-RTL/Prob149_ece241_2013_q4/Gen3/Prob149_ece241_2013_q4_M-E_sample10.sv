module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] prev_s;
    reg level_was_rising;
    wire level_rising;

    // Store previous sensor values and detect rising level
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
            level_was_rising <= 1'b0;
        end else begin
            prev_s <= s;
            level_was_rising <= level_rising;
        end
    end

    // Rising level detection (current level is higher than previous)
    assign level_rising = ((s > prev_s) && (prev_s != 3'b111)) || 
                         ((s == 3'b000) && (prev_s != 3'b000));

    // Output logic - purely combinational
    always @(*) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} = 4'b1111;
        end else begin
            // Base flow rates based on current sensor state
            case (s)
                3'b111: {fr2, fr1, fr0} = 3'b000;  // Above s[2]
                3'b011: {fr2, fr1, fr0} = 3'b001;  // Between s[2] and s[1]
                3'b001: {fr2, fr1, fr0} = 3'b011;  // Between s[1] and s[0]
                3'b000: {fr2, fr1, fr0} = 3'b111;  // Below s[0]
                default: {fr2, fr1, fr0} = 3'b000; // Invalid pattern
            endcase

            // Supplemental flow (dfr) when level is rising and not at max
            dfr = level_rising && (s != 3'b111) && 
                 ((s == 3'b011) || (s == 3'b001));
        end
    end

endmodule