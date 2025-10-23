module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Compute next state based on inputs and current state
wire next_state = (b) ? ((a) ? ~state : 1'b1) : state;

// Output q is the next state except when both a and b are 1, then it's the complement
assign q = (a & b) ? ~next_state : next_state;

// Update state on positive clock edge
always @(posedge clk) begin
    state <= next_state;
end

endmodule