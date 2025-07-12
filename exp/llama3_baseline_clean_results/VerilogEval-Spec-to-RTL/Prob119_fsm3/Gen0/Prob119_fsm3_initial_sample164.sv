module TopModule (
    input        clk,
    input        areset,
    input        in,
    output logic out
);

// Define the states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_type;

state_type state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        A: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        B: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        C: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
            out = 0;
        end
        D: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 1;
        end
        default: begin
            next_state = A;
            out = 0;
        end
    endcase
end

endmodule