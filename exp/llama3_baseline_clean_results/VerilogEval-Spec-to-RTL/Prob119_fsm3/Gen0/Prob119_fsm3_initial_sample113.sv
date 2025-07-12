module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// Initialize the current state
state_t current_state;

// Combinational logic to determine the next state
always_comb begin
    state_t next_state;
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
    assign out = (current_state == D) ? 1'b1 : 1'b0;
end

// Sequential logic to update the current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        state_t next_state;
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
        current_state <= next_state;
    end
end

endmodule