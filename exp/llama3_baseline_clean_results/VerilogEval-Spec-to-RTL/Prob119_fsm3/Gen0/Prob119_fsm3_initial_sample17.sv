module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare the current state and next state
reg [1:0] state;
reg [1:0] next_state;

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state A
        state <= A;
    end else begin
        // Update the state on the positive edge of the clock
        state <= next_state;
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        A: next_state = (in == 0) ? A : B;
        B: next_state = (in == 0) ? C : B;
        C: next_state = (in == 0) ? A : D;
        D: next_state = (in == 0) ? C : B;
        default: next_state = A; // Default to state A
    endcase
end

// Combinational logic to generate the output
always @(*) begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // Default output to 0
    endcase
end

endmodule