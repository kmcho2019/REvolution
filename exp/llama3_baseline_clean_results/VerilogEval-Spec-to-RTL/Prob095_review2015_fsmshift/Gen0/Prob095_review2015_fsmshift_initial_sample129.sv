module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter; // Counter to keep track of the number of cycles

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b1; // Assert shift_ena when reset is asserted
        counter <= 2'd0; // Reset counter
    end else if (counter == 4'd3) begin // After 4 cycles, deassert shift_ena
        shift_ena <= 1'b0;
    end else if (shift_ena) begin
        counter <= counter + 1'b1; // Increment counter when shift_ena is asserted
    end
end

endmodule