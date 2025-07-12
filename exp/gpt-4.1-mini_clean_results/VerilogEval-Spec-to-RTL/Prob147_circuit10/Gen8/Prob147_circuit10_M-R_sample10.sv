module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Define next_state combinationally
assign next_state = b ? ((a) ? ~state : 1'b0) : state;

// Sequential state update at posedge clk
always @(posedge clk) begin
    state <= next_state;
end

// Output logic as combinational assignment
assign q = (a & b) ? 1'b1 : state;

endmodule