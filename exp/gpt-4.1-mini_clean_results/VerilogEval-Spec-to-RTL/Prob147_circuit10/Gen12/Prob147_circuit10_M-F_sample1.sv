module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;
wire q_internal;

assign next_state = (state & ~b) | (a & b);
assign q_internal = (state & ~a) | b;

always @(posedge clk) begin
    state <= next_state;
end

assign q = q_internal;

initial begin
    state = 1'b0;
end

endmodule