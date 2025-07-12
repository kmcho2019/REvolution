module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] counter; // Counter to keep track of clock cycles after reset

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b1; // Enable shift register on reset
        counter <= 2'd0;   // Reset counter
    end else if (counter < 4'd4) begin
        shift_ena <= 1'b1; // Keep shift register enabled for 4 cycles
        counter <= counter + 1'b1; // Increment counter
    end else begin
        shift_ena <= 1'b0; // Disable shift register after 4 cycles
    end
end

endmodule