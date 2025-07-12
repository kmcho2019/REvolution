module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [2:0] counter;  // 3 bits enough to count to 4

    // Pattern detection stub (not part of the interface)
    // Here assumed always zero (no pattern detection),
    // so only reset triggers the pulse.
    wire pattern_detected = 1'b0;

    always @(posedge clk) begin
        if (reset || pattern_detected) begin
            counter <= 3'd4;  // Load count for 4 cycles
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
        // else counter stays at zero
    end

    always @(posedge clk) begin
        shift_ena <= (counter != 0);
    end

endmodule