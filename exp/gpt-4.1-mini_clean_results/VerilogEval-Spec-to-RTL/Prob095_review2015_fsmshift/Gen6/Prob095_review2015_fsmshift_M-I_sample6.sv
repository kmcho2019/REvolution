module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire pattern_detected, // added input for pattern detection
    output wire shift_ena
);

    reg [2:0] counter;

    // Load counter with 4 when reset or pattern_detected occurs, then count down to 0
    always @(posedge clk) begin
        if (reset)
            counter <= 3'd4;
        else if (pattern_detected)
            counter <= 3'd4;
        else if (counter != 0)
            counter <= counter - 1;
    end

    assign shift_ena = (counter != 0);

endmodule