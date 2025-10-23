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

    // Store previous sensor values for edge detection
    always @(posedge clk) begin
        if (reset) begin
            prev_s <= 3'b000;
        end else begin
            prev_s <= s;
        end
    end

    // Determine if water level is rising (any sensor newly covered)
    wire level_rising = (s[0] & ~prev_s[0]) |  // s[0] newly covered
                       (s[1] & ~prev_s[1]) |  // s[1] newly covered
                       (s[2] & ~prev_s[2]);   // s[2] newly covered

    // Output logic (registered)
    always @(posedge clk) begin
        if (reset) begin
            // Reset condition: all outputs high (maximum flow)
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            // Nominal flow outputs based on current sensor readings
            casez (s)
                3'b111: {fr2, fr1, fr0} <= 3'b000;  // Above s[2]
                3'b011: {fr2, fr1, fr0} <= 3'b001;   // Between s[2]-s[1]
                3'b001: {fr2, fr1, fr0} <= 3'b011;   // Between s[1]-s[0]
                3'b000: {fr2, fr1, fr0} <= 3'b111;   // Below s[0]
                default: {fr2, fr1, fr0} <= 3'b000;  // Invalid pattern
            endcase

            // Supplemental flow when level is rising and not at maximum
            dfr <= level_rising && (s != 3'b111);
        end
    end

endmodule