module TopModule (
    input  wire clk,
    input  wire reset,             // synchronous active-high reset
    input  wire pattern_detected,  // pattern detection trigger
    output wire shift_ena
);

    reg [2:0] shift_counter;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, reload counter to 4
            shift_counter <= 3'd4;
        end else if (pattern_detected) begin
            // On pattern detected, reload counter to 4
            shift_counter <= 3'd4;
        end else if (shift_counter != 0) begin
            // Count down if non-zero
            shift_counter <= shift_counter - 1;
        end
    end

    // shift_ena is high whenever counter is non-zero
    assign shift_ena = (shift_counter != 0);

endmodule