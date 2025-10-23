module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

// Define states as an enumeration
enum logic [1:0] {A, B, C, D} current_state, next_state;

// Define the next state logic
always_comb begin
    case (current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

// Define the output logic
always_comb begin
    case (current_state)
        A: out = 0;
        B: out = 0;
        C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// Define the sequential logic block to update the current state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule