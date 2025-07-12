module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire pattern_detected,  // New input for bit pattern detection
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;               // Load 4 on synchronous reset
        end else if (pattern_detected) begin
            counter <= 3'd4;               // Load 4 on pattern detection
        end else if (counter != 0) begin
            counter <= counter - 1;        // Count down when enabled
        end
    end

    assign shift_ena = (counter != 0);

endmodule