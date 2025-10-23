module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_type;

// Reg to store the current state
reg [2:0] current_state;
reg [2:0] next_state;

// Combinational always block to calculate the next state
always @(*) begin
    case (current_state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
    endcase
end

// Sequential always block to update the state on the positive edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Output z is a function of the current state
assign z = (current_state == E) || (current_state == F);

endmodule