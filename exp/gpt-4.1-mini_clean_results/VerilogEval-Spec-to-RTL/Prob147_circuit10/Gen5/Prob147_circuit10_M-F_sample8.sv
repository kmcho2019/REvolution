module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Next state logic
wire next_state;

assign next_state = (b & ~a) | (b & a & ~state);

// Output logic
assign q = state & ~(a & b);

// State register update
always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule