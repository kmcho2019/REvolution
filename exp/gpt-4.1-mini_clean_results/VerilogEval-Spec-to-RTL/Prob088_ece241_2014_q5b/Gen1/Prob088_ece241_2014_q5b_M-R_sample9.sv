module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded states as separate bits
reg state_A;
reg state_B;

// Next state signals
wire next_state_A;
wire next_state_B;

// Next state logic
assign next_state_A = (state_A && ~x) || areset;
assign next_state_B = (state_A && x) || state_B;

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

// Output logic (Mealy): depends on current state and input x
always @(*) begin
    if (state_A)
        z = x;         // z=0 when x=0, z=1 when x=1
    else if (state_B)
        z = ~x;        // z=1 when x=0, z=0 when x=1
    else
        z = 1'b0;      // default output for safety
end

endmodule