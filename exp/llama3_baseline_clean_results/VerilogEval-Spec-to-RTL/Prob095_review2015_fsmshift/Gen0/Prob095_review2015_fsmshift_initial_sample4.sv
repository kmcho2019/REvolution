module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter; // 2-bit counter to count up to 3 (0 to 3)

always @(posedge clk) begin
    if (reset) begin
        // Reset is active high, so if it's high, reset the FSM
        shift_ena <= 1'b1; // Enable shift register on reset
        counter <= 2'd0; // Reset counter
    end else begin
        if (counter < 2'd3) begin
            // If counter is less than 4, increment it and keep shift_ena high
            shift_ena <= 1'b1;
            counter <= counter + 1'd1;
        end else begin
            // If counter reaches 4, deassert shift_ena and keep it low
            shift_ena <= 1'b0;
        end
    end
end

endmodule