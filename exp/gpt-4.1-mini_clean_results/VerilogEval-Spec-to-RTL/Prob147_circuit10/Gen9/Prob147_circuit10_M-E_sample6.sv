module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Compute next state based on current state and inputs a,b
wire next_state = (state & ~(a & b)) | (~state & (~a & b));

// Output q is combinational: 1 if state=1 or both a and b are 1
assign q = state | (a & b);

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule