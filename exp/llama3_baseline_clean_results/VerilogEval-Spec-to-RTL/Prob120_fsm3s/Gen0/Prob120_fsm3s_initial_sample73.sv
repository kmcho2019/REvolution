module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
enum logic [1:0] {A, B, C, D} current_state, next_state;

// Synchronous reset
always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always_comb begin
    case(current_state)
        A: next_state = (in == 0)? A : B;
        B: next_state = (in == 0)? C : B;
        C: next_state = (in == 0)? A : D;
        D: next_state = (in == 0)? C : B;
        default: next_state = A; // default to state A
    endcase
end

// Output logic
always_comb begin
    case(current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0; // default output to 0
    endcase
end

endmodule