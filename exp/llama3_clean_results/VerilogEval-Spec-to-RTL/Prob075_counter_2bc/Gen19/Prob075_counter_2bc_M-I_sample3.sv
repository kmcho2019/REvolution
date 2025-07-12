module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Simplified combinational logic to calculate the next state
wire [1:0] next_state;
assign next_state = (areset) ? 2'b01 : 
                    (train_valid) ? ((train_taken && state_reg < 2'b11) ? state_reg + 2'b01 :
                                     (!train_taken && state_reg > 2'b00) ? state_reg - 2'b01 :
                                     state_reg) :
                    state_reg;

// Sequential logic to update the state register with clock gating
reg clk_enable;
assign clk_enable = train_valid; // Enable clock only when training is valid

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else if (clk_enable) begin
        state_reg <= next_state;
    end
end

endmodule