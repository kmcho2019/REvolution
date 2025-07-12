module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Define states
typedef enum logic [2:0] {
    A,  // initial state, under reset
    B,  // set f to 1
    C,  // monitor x
    D,  // set g to 1 and monitor y
    E   // permanent state for g
} state_t;

state_t current_state, next_state;
logic [1:0] x_count;
logic [1:0] y_count;
logic f_reg, g_reg;

// Initialize FSM
initial begin
    current_state = A;
    x_count = 0;
    y_count = 0;
    f_reg = 0;
    g_reg = 0;
end

// State register
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
        x_count <= 0;
        y_count <= 0;
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        current_state <= next_state;
        x_count <= (current_state == C) ? (x ? x_count + 1 : 0) : x_count;
        y_count <= (current_state == D) ? (y ? 0 : y_count + 1) : y_count;
        f_reg <= (current_state == B) ? 1 : 0;
        g_reg <= (current_state == E || current_state == D) ? 1 : 0;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        A: next_state = (resetn) ? B : A;
        B: next_state = C;
        C: next_state = (x_count == 3) ? D : C;
        D: next_state = (y || y_count == 2) ? (y ? E : A) : D;
        E: next_state = E;
        default: next_state = A;
    endcase
end

// Output logic
assign f = f_reg;
assign g = g_reg;

endmodule