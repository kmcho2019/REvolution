module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter; // counter to count down from 4
reg shift_ena_reg; // register for shift_ena

always @ (posedge clk) begin
    if (reset) begin // when reset is high
        counter <= 3; // initialize counter to 3 (will count down from 4)
        shift_ena_reg <= 1'b1; // assert shift_ena
    end else if (counter != 0) begin // when counter is not zero
        counter <= counter - 1; // decrement counter
        shift_ena_reg <= 1'b1; // keep shift_ena asserted
    end else begin // when counter is zero
        shift_ena_reg <= 1'b0; // deassert shift_ena
    end
end

assign shift_ena = shift_ena_reg;

endmodule