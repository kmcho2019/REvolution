module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Enumerate states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// State register
state_t state, nextState;

// Count the number of w = 1 within three clock cycles
reg [1:0] count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
        count <= 0;
        z <= 0;
    end else begin
        state <= nextState;
        if (nextState == B) begin
            count <= 0;
        end else if ((nextState == C || nextState == D) && w == 1) begin
            count <= count + 1;
        end
        // Set z based on count
        if (nextState == D && count == 2) begin
            z <= 1;
        end else begin
            z <= 0;
        end
    end
end

always_comb begin
    case (state)
        A: begin
            if (s == 1) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        B: begin
            nextState = C;
        end
        C: begin
            nextState = D;
        end
        D: begin
            nextState = B; // Reset state to B to start counting again
        end
        default: begin
            nextState = A; // Default to state A
        end
    endcase
end

endmodule