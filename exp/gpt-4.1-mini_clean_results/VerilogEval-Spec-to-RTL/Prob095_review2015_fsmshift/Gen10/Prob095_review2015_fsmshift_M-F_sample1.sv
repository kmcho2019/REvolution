module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            // During reset cycle: initialize counter for 4 enable cycles after reset
            counter <= 3'd4;
            shift_ena <= 1'b0; // shift_ena not asserted during reset cycle
        end else if (counter != 3'd0) begin
            // Assert shift_ena and decrement counter for 4 cycles after reset
            shift_ena <= 1'b1;
            counter <= counter - 3'd1;
        end else begin
            // After 4 cycles, keep shift_ena deasserted indefinitely
            shift_ena <= 1'b0;
        end
    end

endmodule