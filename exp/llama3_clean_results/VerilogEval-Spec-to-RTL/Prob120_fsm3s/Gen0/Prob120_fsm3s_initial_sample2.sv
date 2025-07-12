module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states as enums
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_type;

// Declare current and next state
state_type current_state, next_state;

// Assign output based on current state
always_comb begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

// Update state on positive edge of clock
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= in ? B : A;
            B: current_state <= in ? B : C;
            C: current_state <= in ? D : A;
            D: current_state <= in ? B : C;
        endcase
    end
end

endmodule