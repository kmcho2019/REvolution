module TopModule(
    input  clk,
    input  reset,
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

state_t state, next_state;

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// State transition logic
always_comb begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

// State update logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule