module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic:
// If state==0: next_state = a ^ b
// If state==1: next_state = ~(a & b)
assign next_state = state ? ~(a & b) : (a ^ b);

// Output logic:
// q = (state & ~(a & b)) | (a & b)
assign q = (state & ~(a & b)) | (a & b);

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 0;
end

endmodule