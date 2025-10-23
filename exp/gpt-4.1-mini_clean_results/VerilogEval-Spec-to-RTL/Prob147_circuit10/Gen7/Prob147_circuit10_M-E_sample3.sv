module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic
assign next_state = (state & ~(a & b)) | (~state & ~a & b);

// Output logic
assign q = state ^ (a & b);

always @(posedge clk) begin
    state <= next_state;
end

initial state = 1'b0;

endmodule