module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    reg [2:0] ena_counter;

    // Counter logic: load 4 on reset, decrement if > 0 otherwise hold at 0
    always @(posedge clk) begin
        if (reset) begin
            ena_counter <= 3'd4;  // Enable for 4 cycles after reset
        end else if (ena_counter != 3'd0) begin
            ena_counter <= ena_counter - 1;
        end
    end

    // shift_ena asserted when counter is non-zero
    assign shift_ena = (ena_counter != 3'd0);

endmodule