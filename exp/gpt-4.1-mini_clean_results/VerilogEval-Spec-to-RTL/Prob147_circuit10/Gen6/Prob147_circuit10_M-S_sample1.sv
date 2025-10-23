module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = b ? (a ? ~state : 1'b1) : state;

assign q = (a & b) ? 1'b0 : state;

always @(posedge clk) begin
    state <= next_state;
end

endmodule