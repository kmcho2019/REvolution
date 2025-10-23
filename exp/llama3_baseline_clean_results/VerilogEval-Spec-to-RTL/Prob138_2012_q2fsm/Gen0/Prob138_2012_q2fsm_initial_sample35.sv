module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define states
enum logic [2:0] {
    A = 3'b001,
    B = 3'b010,
    C = 3'b011,
    D = 3'b100,
    E = 3'b101,
    F = 3'b110
} state, next_state;

// State flip-flops
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always_comb begin
    case (state)
        A: begin
            if (w) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (w) begin
                next_state = C;
            end else begin
                next_state = D;
            end
        end
        C: begin
            if (w) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (w) begin
                next_state = F;
            end else begin
                next_state = A;
            end
        end
        E: begin
            if (w) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        F: begin
            if (w) begin
                next_state = C;
            end else begin
                next_state = D;
            end
        end
        default: next_state = A; // Default to state A for invalid states
    endcase
end

// Output logic (describe z based on the state)
always_comb begin
    case (state)
        A, B, C, D, E, F: z = 0; // Since there's no specific output condition given for z, 
                                 // let's assume it's always 0 based on the state machine transitions.
        default: z = 0;
    endcase
end

endmodule