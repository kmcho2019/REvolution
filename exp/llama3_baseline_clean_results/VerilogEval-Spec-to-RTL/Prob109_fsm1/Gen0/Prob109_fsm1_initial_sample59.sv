module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
enum logic [0:0] {A, B} state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= B;
    end else begin
        case (state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B; // default state
        endcase
        state <= next_state;
    end
end

// Output is determined solely by the state
always_comb begin
    case (state)
        A: out = 0;
        B: out = 1;
    endcase
end

endmodule