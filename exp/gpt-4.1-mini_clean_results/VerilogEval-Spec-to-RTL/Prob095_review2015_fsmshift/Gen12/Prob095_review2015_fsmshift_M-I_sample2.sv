module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    reg [2:0] count;

    // For demonstration, no external pattern_detected input is given.
    // If pattern detection input exists, connect it here.
    // For now, pattern_detected is internally 0, meaning only reset triggers shift_ena.
    wire pattern_detected = 1'b0;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;            // On reset, enable shift for 4 cycles
        end else if (pattern_detected) begin
            count <= 3'd4;            // On pattern detection, enable shift for 4 cycles
        end else if (count != 0) begin
            count <= count - 1;       // Count down while non-zero
        end
    end

    assign shift_ena = (count != 0);

endmodule