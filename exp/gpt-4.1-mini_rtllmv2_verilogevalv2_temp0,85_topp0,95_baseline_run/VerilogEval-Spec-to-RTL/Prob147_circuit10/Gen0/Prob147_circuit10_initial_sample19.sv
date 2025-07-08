module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Combinational logic for next state
assign next_state = (state & ~(a & b)) | (~state & b);

// Combinational logic for output q
assign q = (state & ~a) | (~state & b);

// Sequential logic: state updated on positive clock edge
always @(posedge clk) begin
    state <= next_state;
end

endmodule