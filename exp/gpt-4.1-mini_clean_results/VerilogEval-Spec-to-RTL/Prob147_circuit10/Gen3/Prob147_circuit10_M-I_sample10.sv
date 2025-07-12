module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire toggle = a & b;
wire set    = ~state & ~a & b;
wire reset  = state & a & ~b;

wire next_state = toggle ? ~state : (set ? 1'b1 : (reset ? 1'b0 : state));

// Output q logic:
// If toggle condition: q = ~state
// Else if a=1, q=0
// Else if b=1, q=1
// Else q=state
assign q = toggle ? ~state : (a ? 1'b0 : (b ? 1'b1 : state));

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule