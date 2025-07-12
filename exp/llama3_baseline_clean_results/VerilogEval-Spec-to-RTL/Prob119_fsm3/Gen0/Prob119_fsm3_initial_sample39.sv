module TopModule(
    input        clk,
    input        areset,
    input        in,
    output logic out
);

// Define the states of the FSM
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

state_t current_state, next_state;

// Sequential logic to update the current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to determine the next state and output
always_comb begin
    case (current_state)
        A: begin
            if (in == 1'b0) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (in == 1'b0) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        C: begin
            if (in == 1'b0) begin
                next_state = A;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (in == 1'b0) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
    endcase

    // Determine the output based on the current state
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule