module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter; // counter to keep track of the number of cycles

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1; // assert shift_ena on reset
        counter <= 2'd0; // reset counter
    end else if (counter < 4) begin
        shift_ena <= 1; // keep shift_ena asserted for 4 cycles
        counter <= counter + 1; // increment counter
    end else begin
        shift_ena <= 0; // deassert shift_ena after 4 cycles
    end
end

endmodule