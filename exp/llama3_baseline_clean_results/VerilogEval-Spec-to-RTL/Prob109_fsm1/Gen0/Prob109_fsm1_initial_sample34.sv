module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
enum logic [0:0] {A, B} state, next_state;

// Output logic
always_comb begin
    case (state)
        A: out = 0;
        B: out = 1;
    endcase
end

// Next state logic
always_comb begin
    case (state)
        A: begin
            if (~in) next_state = B;
            else next_state = A;
        end
        B: begin
            if (in) next_state = B;
            else next_state = A;
        end
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) state <= B;
    else state <= next_state;
end

endmodule