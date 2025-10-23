module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter; // counter to keep track of the number of clock cycles

always @(posedge clk) begin
    if (reset) begin // if reset is high
        shift_ena <= 1'b1; // assert shift_ena
        counter <= 2'd0; // reset counter
    end else if (counter < 4'd4) begin // if counter is less than 4
        shift_ena <= 1'b1; // assert shift_ena
        counter <= counter + 1'b1; // increment counter
    end else begin
        shift_ena <= 1'b0; // deassert shift_ena
    end
end

endmodule