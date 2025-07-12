module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

// Simplified combinational logic for next state calculation
wire [1:0] next_state;
assign next_state = (train_valid)? 
                    ((train_taken && state_reg < 2'b11)? state_reg + 1 :
                     (!train_taken && state_reg > 2'b00)? state_reg - 1 : state_reg) :
                    state_reg;

// Sequential logic with clock gating for state update
reg clk_enable;
assign clk_enable = train_valid;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01;
    end else if (clk_enable) begin
        state_reg <= next_state;
    end
end

assign state = state_reg;

endmodule