module TopModule (
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter; // 2-bit counter to count up to 3 (4 cycles)

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b1; // assert shift_ena when reset is high
        counter <= 2'd0; // reset counter
    end else if (counter < 4) begin
        shift_ena <= 1'b1; // keep shift_ena high for 4 cycles
        counter <= counter + 1; // increment counter
    end else begin
        shift_ena <= 1'b0; // deassert shift_ena after 4 cycles
    end
end

endmodule