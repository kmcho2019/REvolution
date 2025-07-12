module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} currentState, nextState;

// Determine z based on current state
always_comb begin
    case (currentState)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

// Determine next state based on current state and input w
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
        default: nextState = A;
    endcase
end

// Update state on positive edge of clock
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule