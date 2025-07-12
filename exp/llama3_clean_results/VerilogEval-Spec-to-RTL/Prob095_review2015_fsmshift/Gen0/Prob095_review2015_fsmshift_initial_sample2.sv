module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter; // counter to keep track of the number of clock cycles

always @(posedge clk) begin
    if (reset) begin // if reset is high, assert shift_ena and reset counter
        shift_ena <= 1'b1;
        counter <= 2'd0;
    end else if (counter < 4) begin // if counter is less than 4, increment counter and assert shift_ena
        shift_ena <= 1'b1;
        counter <= counter + 1'b1;
    end else begin // if counter is 4 or more, de-assert shift_ena
        shift_ena <= 1'b0;
    end
end

endmodule