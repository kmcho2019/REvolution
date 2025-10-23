module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state, nextState;

// Define states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Output z depends on the current state
assign z = state[2]; // z is high when state is E or F

always @(*) begin
    case (state)
        A: begin
            if (~w) nextState = B;
            else nextState = A;
        end
        B: begin
            if (~w) nextState = C;
            else nextState = D;
        end
        C: begin
            if (~w) nextState = E;
            else nextState = D;
        end
        D: begin
            if (~w) nextState = F;
            else nextState = A;
        end
        E: begin
            if (w) nextState = D;
            else nextState = E;
        end
        F: begin
            if (w) nextState = D;
            else nextState = C;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) state <= A;
    else state <= nextState;
end

endmodule