module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states
enum logic [1:0] {
    A,
    B,
    C,
    D
} current_state, next_state;

always @(*) begin
    case (current_state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule