module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter;  // 2-bit counter to count 4 cycles
reg state;  // 1-bit state variable (IDLE = 0, SHIFT = 1)

always @(posedge clk) begin
    if (reset) begin
        state <= 1;  // Start shifting when reset
        counter <= 0;  // Reset counter
    end else if (state) begin
        if (counter < 4) begin
            counter <= counter + 1;  // Increment counter
        end else begin
            state <= 0;  // Stop shifting after 4 cycles
        end
    end
end

always @(posedge clk) begin
    if (reset || state) begin
        shift_ena <= 1;  // Assert shift_ena when shifting
    end else begin
        shift_ena <= 0;  // Deassert shift_ena when not shifting
    end
end

endmodule