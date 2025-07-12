module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
reg [1:0] next_state;

// Combinational logic to calculate the next state
assign next_state = (areset) ? 2'b01 :
                    (train_valid) ? (train_taken) ? (state_reg == 2'b11) ? 2'b11 : state_reg + 1 :
                                             (state_reg == 2'b00) ? 2'b00 : state_reg - 1 :
                    state_reg;

// Sequential logic to update the state register
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else begin
        state_reg <= next_state;
    end
end

assign state = state_reg; // Continuous assignment to output the counter value

endmodule