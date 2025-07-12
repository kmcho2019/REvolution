module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} currentState, nextState;

// Output z is 1 when the state machine is in state E or F
assign z = (currentState == E) || (currentState == F);

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Combinational logic for next state
always_comb begin
    case (currentState)
        A: begin
            if (w) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        C: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        D: begin
            if (w) begin
                nextState = A;
            end else begin
                nextState = F;
            end
        end
        E: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        F: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        default: begin
            nextState = A;
        end
    endcase
end

endmodule