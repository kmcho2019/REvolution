module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// State register: single flip-flop represents state_A (1 = state A, 0 = state B)
reg state_A;
wire state_B = ~state_A;

// Next state logic
wire next_state_A = state_A & ~x; // from A: stay in A if x=0, else go to B (state_A=0)

// Mealy output combinational logic (next value of output)
wire z_next = (state_A & x) | (state_B & ~x);

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1; // reset into state A
        z       <= 1'b0; // reset output to 0
    end else begin
        state_A <= next_state_A;
        z       <= z_next;
    end
end

endmodule