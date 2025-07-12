module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define states
enum logic [2:0] {
    StateA = 3'b000,
    StateB = 3'b001,
    StateC = 3'b010,
    StateD = 3'b011,
    StateE = 3'b100,
    StateF = 3'b101
} current_state, next_state;

logic [1:0] x_sequence; // To track the sequence of x
logic [1:0] y_timer;    // To count cycles in State E

always_ff @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        current_state <= StateA;
        x_sequence <= 2'b00;
        y_timer <= 2'b00;
        f <= 0;
        g <= 0;
    end else begin
        current_state <= next_state;
        x_sequence <= (current_state == StateC) ? {x_sequence[0], x} : x_sequence;
        y_timer <= (current_state == StateE) ? y_timer + 1 : 0;
        f <= (current_state == StateB) ? 1 : 0;
        g <= (current_state == StateD || current_state == StateE) ? 1 : 0;
    end
end

always_comb begin
    case (current_state)
        StateA: if (~resetn) next_state = StateA;
                else next_state = StateB;
        StateB: next_state = StateC;
        StateC: if (x_sequence == 2'b11 && x == 1'b1) next_state = StateD;
                else next_state = StateC;
        StateD: next_state = StateE;
        StateE: if (y || y_timer == 2'b10) next_state = (y) ? StateE : StateF;
                else next_state = StateE;
        StateF: next_state = StateF;
        default: next_state = StateA;
    endcase
end

endmodule