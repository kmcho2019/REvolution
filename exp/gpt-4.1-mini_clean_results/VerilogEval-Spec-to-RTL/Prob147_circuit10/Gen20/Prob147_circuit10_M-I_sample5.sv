module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Next state logic:
// If state=0 and b=1 -> next_state=1
// If state=1 and a=1 and b=0 -> next_state=0
// Else state unchanged as per formula:
assign next_state = (state & ~(a & ~b)) | (~state & b);

// Output q logic:
// q=1 when (state=0 and b=1) OR (state=1 and (a=1 OR b=1))
assign q = (state & (a | b)) | (~state & b);

always @(posedge clk) begin
    state <= next_state;
end

endmodule