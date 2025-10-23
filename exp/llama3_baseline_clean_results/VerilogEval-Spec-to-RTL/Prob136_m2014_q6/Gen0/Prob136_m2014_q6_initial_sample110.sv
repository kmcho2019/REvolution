module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

state_t current_state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        A: begin
            if (w == 1'b1) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (w == 1'b1) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        C: begin
            if (w == 1'b1) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        D: begin
            if (w == 1'b1) begin
                next_state = A;
            end else begin
                next_state = F;
            end
        end
        E: begin
            if (w == 1'b1) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        F: begin
            if (w == 1'b1) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        default: next_state = A;
    endcase
end

// Since the output z is not specified in the state machine, we'll just assign it to 1 for states E and F where w is 1, and 0 otherwise
always_comb begin
    case (current_state)
        E, F: z = w;
        default: z = 1'b0;
    endcase
end

endmodule