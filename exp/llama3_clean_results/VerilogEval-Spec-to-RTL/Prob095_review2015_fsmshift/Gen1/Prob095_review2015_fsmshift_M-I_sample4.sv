module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] counter; // counter to keep track of clock cycles
reg shift_ena_reg; // register to store the value of shift_ena

// initialize counter and shift_ena
initial begin
    counter = 2'b00;
    shift_ena_reg = 1'b0;
end

// sequential logic
always @(posedge clk) begin
    if (reset) begin // if reset is asserted
        counter = 4'b1000; // set counter to 4 (will decrement to 0 in 4 clock cycles)
        shift_ena_reg = 1'b1; // set shift_ena to 1
    end
    else if (counter > 0) begin // if counter is not 0
        counter = counter - 1; // decrement counter
        shift_ena_reg = 1'b1; // keep shift_ena asserted
    end
    else begin // if counter is 0
        shift_ena_reg = 1'b0; // set shift_ena to 0
    end
end

// continuous assignment
assign shift_ena = shift_ena_reg;

endmodule