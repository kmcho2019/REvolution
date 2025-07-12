module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the state

// Combinational logic to calculate the next state
wire [1:0] next_state;
assign next_state = (train_valid && train_taken)? (state_reg + 2'b01) :
                    (train_valid &&!train_taken)? (state_reg - 2'b01) :
                    state_reg;

// Saturation circuit to ensure the counter value remains within the range of 0 to 3
wire [1:0] saturated_next_state;
assign saturated_next_state = (next_state > 2'b11)? 2'b11 :
                                (next_state < 2'b00)? 2'b00 :
                                next_state;

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset to the weakly not-taken state
    end else begin
        state_reg <= saturated_next_state;
    end
end

endmodule