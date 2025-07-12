module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define states
parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;

reg [2:0] state; // Current state
reg [2:0] nextState; // Next state

always @(*) begin
    case(state)
        A: nextState = (w)? A : B;
        B: nextState = (w)? D : C;
        C: nextState = (w)? D : E;
        D: nextState = (w)? A : F;
        E: nextState = (w)? D : E;
        F: nextState = (w)? D : C;
        default: nextState = A; // Default to A if state is unknown
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= nextState; // Transition to next state on clock edge
    end
end

assign z = (state == E || state == F)? 1'b1 : 1'b0; // Set z based on state

endmodule