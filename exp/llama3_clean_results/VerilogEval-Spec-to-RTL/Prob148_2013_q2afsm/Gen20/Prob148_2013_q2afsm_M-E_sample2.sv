module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define states for the FSM
enum logic [1:0] {A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11} state, nextState;

// Priority decoder output
logic [1:0] priorityOutput;

// Priority decoder logic
always_comb begin
    if (r[0]) priorityOutput = B; // Highest priority to device 0
    else if (r[1]) priorityOutput = C; // Next priority to device 1
    else if (r[2]) priorityOutput = D; // Lowest priority to device 2
    else priorityOutput = A; // No requests
end

// State machine logic
always_comb begin
    case (state)
        A: nextState = (priorityOutput != A) ? priorityOutput : A;
        B: nextState = (r[0]) ? B : A;
        C: nextState = (r[1]) ? C : A;
        D: nextState = (r[2]) ? D : A;
        default: nextState = A;
    endcase
end

// State register
always_ff @(posedge clk) begin
    if (~resetn) state <= A;
    else state <= nextState;
end

// Output logic
assign g[0] = (state == B);
assign g[1] = (state == C);
assign g[2] = (state == D);

endmodule