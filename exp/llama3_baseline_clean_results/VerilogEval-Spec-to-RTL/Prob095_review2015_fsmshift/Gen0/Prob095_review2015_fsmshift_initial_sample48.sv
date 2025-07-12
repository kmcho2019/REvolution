module TopModule (
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter; // 2-bit counter to count up to 3 (4 cycles)
reg       shift_ena_reg; // Register to hold the value of shift_ena

always @(posedge clk) begin
    if (reset) begin
        counter <= 2'b00; // Reset counter to 0 when reset is asserted
        shift_ena_reg <= 1'b1; // Assert shift_ena when reset is asserted
    end else if (counter < 4) begin
        counter <= counter + 1'b1; // Increment counter
        shift_ena_reg <= 1'b1; // Keep shift_ena asserted
    end else begin
        shift_ena_reg <= 1'b0; // Deassert shift_ena after 4 cycles
    end
end

assign shift_ena = shift_ena_reg;

endmodule