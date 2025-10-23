module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter; // counter to keep track of the number of clock cycles
reg shifting; // signal to track the current state of the FSM

always @(posedge clk) begin
    if (reset) begin // if reset is high, reset counter, assert shift_ena, and enter shifting state
        shift_ena <= 1'b1;
        counter <= 2'd0;
        shifting <= 1'b1;
    end else if (shifting && counter < 4) begin // if in shifting state and counter is less than 4, increment counter
        shift_ena <= 1'b1;
        counter <= counter + 1'b1;
    end else if (shifting && counter == 4) begin // if in shifting state and counter is 4, de-assert shift_ena and exit shifting state
        shift_ena <= 1'b0;
        shifting <= 1'b0;
    end else begin // if not in shifting state, keep shift_ena de-asserted
        shift_ena <= 1'b0;
    end
end

endmodule