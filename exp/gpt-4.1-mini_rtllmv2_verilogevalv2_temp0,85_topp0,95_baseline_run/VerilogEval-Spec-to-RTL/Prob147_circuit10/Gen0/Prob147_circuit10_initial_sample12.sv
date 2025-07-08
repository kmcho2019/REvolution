module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire q_internal;

// Combinational logic for q
assign q_internal = (state & ~a & ~b) | (~state & ((a & ~b) | (~a & b)));

assign q = q_internal;

always @(posedge clk) begin
    state <= q_internal;
end

endmodule