module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
enum logic [0:0] {B, A} state, next_state;

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        B: next_state = (in == 0) ? A : B;
        A: next_state = (in == 0) ? B : A;
        default: next_state = B;
    endcase
end

// Output logic
always @(*) begin
    case (state)
        B: out = 1;
        A: out = 0;
        default: out = 1;
    endcase
end

endmodule