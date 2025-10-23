module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

enum logic [0:0] {B, A} state, next_state;

always @(posedge clk) begin
    if(reset) begin
        state <= B; // Reset state is B
    end else begin
        state <= next_state; // Update state
    end
end

always @(*) begin
    case(state)
        B: next_state = (in == 0)? A : B;
        A: next_state = (in == 0)? B : A;
    endcase
end

assign out = (state == B)? 1'b1 : 1'b0; // Output is 1 in state B and 0 in state A

endmodule