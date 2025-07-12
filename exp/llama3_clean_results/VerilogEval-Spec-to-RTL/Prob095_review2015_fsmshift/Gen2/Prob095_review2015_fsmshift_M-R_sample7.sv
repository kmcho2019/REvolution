module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] counter; // counter to keep track of clock cycles

// sequential logic
always @(posedge clk) begin
    if (reset) begin // if reset is asserted
        counter = 4; // set counter to 4
    end
    else if (counter > 0) begin // if counter is not 0
        counter = counter - 1; // decrement counter
    end
end

// continuous assignment
assign shift_ena = (counter > 0) ? 1'b1 : 1'b0;

endmodule