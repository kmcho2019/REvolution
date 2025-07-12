module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

assign next_state = (a & b) ? 1'b0 :
                    b       ? 1'b1 :
                    a       ? state :
                              1'b0;

assign q = (state & a) | (~state & b);

always @(posedge clk) begin
    state <= next_state;
end

initial state = 1'b0;

endmodule