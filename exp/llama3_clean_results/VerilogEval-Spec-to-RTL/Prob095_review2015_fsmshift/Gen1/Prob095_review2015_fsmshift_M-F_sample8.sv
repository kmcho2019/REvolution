module TopModule(
    input  clk,
    input  reset,
    output shift_ena
);

reg [1:0] state; // 2 states: 2'b00 (RESET_STATE), 2'b01 (NORMAL_STATE)
reg [1:0] counter; // counter to keep track of clock cycles in RESET_STATE
reg shift_ena_reg; // register to store the value of shift_ena

// initialize state and counter
initial begin
    state = 2'b01; // start in NORMAL_STATE
    counter = 2'b00;
    shift_ena_reg = 1'b0;
end

// sequential logic
always @(posedge clk) begin
    if (reset) begin // if reset is asserted
        state <= 2'b00; // transition to RESET_STATE
        counter <= 2'b10; // set counter to 4 (will decrement to 0 in 4 clock cycles)
        shift_ena_reg <= 1'b1; // set shift_ena to 1
    end
    else if (state == 2'b00) begin // if in RESET_STATE
        if (counter!= 2'b00) begin // if counter is not 0
            counter <= counter - 1; // decrement counter
        end
        else begin // if counter is 0
            state <= 2'b01; // transition to NORMAL_STATE
            shift_ena_reg <= 1'b0; // set shift_ena to 0
        end
    end
    else if (state == 2'b01) begin // if in NORMAL_STATE
        shift_ena_reg <= 1'b0; // set shift_ena to 0
    end
end

// continuous assignment
assign shift_ena = shift_ena_reg;

endmodule