module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Combinational logic for output q
assign q = (state & (~a | b)) | (~state & a & ~b);

// Next state is updated with q at clock edge
assign next_state = q;

always @(posedge clk) begin
    state <= next_state;
end

endmodule