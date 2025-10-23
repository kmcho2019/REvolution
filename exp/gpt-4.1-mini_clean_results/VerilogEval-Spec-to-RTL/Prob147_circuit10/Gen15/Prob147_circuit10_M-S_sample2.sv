module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic simplified:
assign next_state = (state & ~(a & b)) | (~state & b);

// Output q is equal to next_state combinationally:
assign q = next_state;

always @(posedge clk) begin
    state <= next_state;
end

endmodule