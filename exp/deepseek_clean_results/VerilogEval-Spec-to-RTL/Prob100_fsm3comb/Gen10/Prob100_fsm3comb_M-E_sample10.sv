module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

always @(*) begin
    // Arithmetic implementation of state transitions
    next_state = (state & {in, ~in}) + ({in, in} & state);
end

assign out = (state == 2'b11); // Output 1 only in state D

endmodule