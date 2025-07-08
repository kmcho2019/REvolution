module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire q_internal;

// Combinational logic for q
assign q_internal = (a & ~b) | (~a & b & ~state) | (state & a & b);
assign q = q_internal;

// Sequential logic: state flip-flop
always @(posedge clk) begin
    state <= q_internal;
end

endmodule