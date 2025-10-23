module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states as enumerations
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

// Current state register
reg state_t current_state;

// Next-state logic
wire state_t next_state;

// Combinational logic for next-state
assign next_state = (current_state == A)  ? (w ? B : A) :
                     (current_state == B)  ? (w ? C : D) :
                     (current_state == C)  ? (w ? E : D) :
                     (current_state == D)  ? (w ? F : A) :
                     (current_state == E)  ? (w ? E : D) :
                     (current_state == F)  ? (w ? C : D) :
                     A; // Default to state A

// Sequential logic for state register
always @ (posedge clk) begin
    if (reset) begin
        current_state <= A; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Output z logic
assign z = (current_state == E) || (current_state == F);

endmodule