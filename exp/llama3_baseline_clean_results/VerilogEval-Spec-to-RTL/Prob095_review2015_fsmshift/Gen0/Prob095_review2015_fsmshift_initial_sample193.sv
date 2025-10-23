module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter; // 2-bit counter to track the number of clock cycles

always @(posedge clk) begin
    if (reset) begin // Reset is active high
        counter <= 2'b00; // Reset the counter
        shift_ena <= 1'b1; // Assert shift_ena immediately after reset
    end else if (counter < 4) begin // If the counter is less than 4
        counter <= counter + 1'b1; // Increment the counter
        shift_ena <= 1'b1; // Keep shift_ena asserted
    end else begin
        shift_ena <= 1'b0; // Deassert shift_ena after 4 cycles
    end
end

endmodule