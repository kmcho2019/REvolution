module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Next state depends on b, a, and current state
wire next_state;
assign next_state = b ? ~a : state;

always @(posedge clk) begin
    state <= next_state;
end

assign q = state & a;

endmodule