module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire pattern_detected,  // Added input for pattern detection event
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, assert shift_ena for 4 cycles
            counter <= 3'd4;
        end else if (pattern_detected && counter == 3'd0) begin
            // On detection of pattern (only if not already counting),
            // assert shift_ena for 4 cycles
            counter <= 3'd4;
        end else if (counter != 3'd0) begin
            // Count down when active
            counter <= counter - 1;
        end
        // else counter remains zero (shift_ena low)
    end

    assign shift_ena = (counter != 3'd0);

endmodule