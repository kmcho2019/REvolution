module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic
assign next_state = (state & ~(a & b)) | (~state & b & ~a);

// Output logic q
assign q = (state & ~a) | (~state & a & b);

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule