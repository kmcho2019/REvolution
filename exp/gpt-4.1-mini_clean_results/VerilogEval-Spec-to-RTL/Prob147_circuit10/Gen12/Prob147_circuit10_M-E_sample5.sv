module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = b ? ~a : state;       // Update state to inverted 'a' if b=1 else hold
assign q = state & (~a | ~b);              // q=1 when state=1 and (a=0 or b=0)

always @(posedge clk) begin
    state <= next_state;
end

endmodule