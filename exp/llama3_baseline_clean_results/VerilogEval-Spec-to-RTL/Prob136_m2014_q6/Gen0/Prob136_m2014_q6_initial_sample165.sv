module TopModule(
    input  clk,
    input  reset,
    input  w,
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
} state, nextState;

// State register
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

// Next state logic
always_comb begin
    case (state)
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
        default: nextState = A; // Default to state A for invalid states
    endcase
end

// Output logic (example, adjust according to actual requirements)
assign z = (state == E || state == F); // Example: z is high for states E and F

endmodule