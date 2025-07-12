module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg [1:0] state_counter; // Counter to track state transitions

// Sequential logic to update state_counter
always @(posedge clk or posedge areset)
begin
    if (areset) state_counter <= 2'b10; // Reset to state B (counter value 2)
    else if (state_counter == 2'b10) // Currently in state B
    begin
        if (in) state_counter <= 2'b10; // Stay in state B
        else state_counter <= 2'b00; // Transition to state A
    end
    else if (state_counter == 2'b00) // Currently in state A
    begin
        if (in) state_counter <= 2'b00; // Stay in state A
        else state_counter <= 2'b10; // Transition to state B
    end
end

// Output logic (Moore machine, output based on state_counter)
assign out = (state_counter == 2'b10)? 1'b1 : 1'b0;

endmodule