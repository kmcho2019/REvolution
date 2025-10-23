module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// Define states as enumerations for clarity
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_type;

reg [2:0] state; // State register
reg [2:0] next_state; // Next state register

// State machine
always @ (posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always @ (*) begin
    case (state)
        A: next_state = w ? B : A;
        B: next_state = w ? C : D;
        C: next_state = w ? E : D;
        D: next_state = w ? F : A;
        E: next_state = w ? E : D;
        F: next_state = w ? C : D;
        default: next_state = A; // Default to state A
    endcase
end

// Output z
always @ (posedge clk) begin
    if (state == E || state == F) begin
        z <= 1'b1;
    end else begin
        z <= 1'b0;
    end
end

endmodule