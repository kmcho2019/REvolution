module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter; // Counter to count cycles after reset

always @(posedge clk) begin
    if (reset) begin
        // On reset, assert shift_ena and start counting
        shift_ena <= 1'b1;
        counter <= 2'd0;
    end else if (counter < 4) begin
        // Keep shift_ena high for 4 cycles after reset
        shift_ena <= 1'b1;
        counter <= counter + 1'b1;
    end else begin
        // After 4 cycles, keep shift_ena low
        shift_ena <= 1'b0;
    end
end

endmodule