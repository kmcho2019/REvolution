module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

// State variable
reg state; // 1 represents state B, 0 represents state A

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) 
        state <= 1'b1; // Reset to state B
    else 
    begin
        case(state)
            1'b1: state <= in? 1'b1 : 1'b0; // State B transitions
            1'b0: state <= in? 1'b0 : 1'b1; // State A transitions
            default: state <= 1'b1; // Default to state B on unknown state
        endcase
    end
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule