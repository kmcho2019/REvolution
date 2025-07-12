module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states
enum {A, B} state, next_state;

// Combinational logic to determine the next state
always @(*) begin
    case(state)
        B: next_state = in ? B : A;
        A: next_state = in ? A : B;
        default: next_state = B;
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= B;
        out <= 1'b1;
    end else begin
        state <= next_state;
        out <= state == B ? 1'b1 : 1'b0;
    end
end

endmodule