module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} current_state, next_state;

// Combinational logic to determine next state
always_comb begin
    case(current_state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

// Sequential logic to update current state
always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
        z <= 0;
    end else begin
        current_state <= next_state;
        z <= (current_state == E || current_state == F);
    end
end

endmodule