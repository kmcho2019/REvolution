module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
enum logic [0:0] {B, A} state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        B: next_state = (in) ? B : A;
        A: next_state = (in) ? A : B;
        default: next_state = B;
    endcase
end

// Output logic
always @(*) begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule