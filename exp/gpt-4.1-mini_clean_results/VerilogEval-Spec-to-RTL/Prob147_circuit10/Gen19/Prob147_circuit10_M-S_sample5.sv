module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (b & ~a) ? 1'b1 :
                    (a & b)  ? 1'b0 :
                    state;

assign q = state;

always @(posedge clk) begin
    state <= next_state;
end

initial state = 1'b0;

endmodule