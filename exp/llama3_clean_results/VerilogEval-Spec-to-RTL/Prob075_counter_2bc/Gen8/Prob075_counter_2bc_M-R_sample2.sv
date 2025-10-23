module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Combinational logic to generate the next state value
wire [1:0] next_state;
assign next_state = (train_valid && train_taken) ? (state_reg == 2'b11) ? 2'b11 : state_reg + 1 :
                     (train_valid && !train_taken) ? (state_reg == 2'b00) ? 2'b00 : state_reg - 1 :
                     state_reg;

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else begin
        state_reg <= next_state; // Update state register
    end
end

endmodule