module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

state_t current_state;
state_t next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        A: begin
            if (in == 0) next_state = A;
            else next_state = B;
        end
        B: begin
            if (in == 0) next_state = C;
            else next_state = B;
        end
        C: begin
            if (in == 0) next_state = A;
            else next_state = D;
        end
        D: begin
            if (in == 0) next_state = C;
            else next_state = B;
        end
        default: next_state = A;
    endcase
end

always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule