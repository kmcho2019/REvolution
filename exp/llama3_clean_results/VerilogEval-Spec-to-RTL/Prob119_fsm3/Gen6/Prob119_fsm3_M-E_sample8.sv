module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states using Gray code
reg [1:0] state;

// Next state logic based on current state and input
reg [1:0] next_state;

always_comb begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00; // A to B or stay in A
        2'b01: next_state = in ? 2'b01 : 2'b11; // B to B or C
        2'b11: next_state = in ? 2'b10 : 2'b00; // C to D or A
        2'b10: next_state = in ? 2'b01 : 2'b11; // D to B or C
    endcase
end

// Output logic based on current state
always_comb begin
    out = (state == 2'b10) ? 1'b1 : 1'b0; // Output is 1 only in state D
end

// Sequential logic for state transition with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule