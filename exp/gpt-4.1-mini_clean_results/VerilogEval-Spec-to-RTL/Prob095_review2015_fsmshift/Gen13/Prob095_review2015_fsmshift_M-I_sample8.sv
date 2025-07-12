module TopModule (
    input  wire clk,
    input  wire reset,            // synchronous active high
    input  wire pattern_detected, // single-cycle pulse indicating pattern detected
    output wire shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;  // start shift_ena for 4 cycles after reset
        end else if (counter == 0 && pattern_detected) begin
            counter <= 3'd4;  // start shift_ena for 4 cycles on pattern detection
        end else if (counter != 0) begin
            counter <= counter - 1;
        end
    end

    assign shift_ena = (counter != 0);

endmodule