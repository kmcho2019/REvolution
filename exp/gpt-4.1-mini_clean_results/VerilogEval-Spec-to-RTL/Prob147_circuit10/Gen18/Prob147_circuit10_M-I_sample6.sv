module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (~a & b) ? 1'b1 :
                    (a & b)  ? 1'b0 :
                    (~a & ~b) ? 1'b0 :
                    state; // when a=1 & b=0 hold state

assign q = state;

always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
end

endmodule