module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

always @(*) begin
    if (in == 0) begin
        // For in=0: rotate left by 1 (A->A, B->C, C->A, D->C)
        next_state = {state[0], ~state[1]};
    end else begin
        // For in=1: special pattern (A->B, B->B, C->D, D->B)
        next_state = (state == 2'b11) ? 2'b01 : (state | 2'b01);
    end
end

assign out = (state == 2'b11); // Output 1 only in state D

endmodule