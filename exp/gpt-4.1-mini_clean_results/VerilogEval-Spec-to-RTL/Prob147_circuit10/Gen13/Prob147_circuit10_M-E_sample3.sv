module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire next_state;

// Combinational logic for output q and next_state
assign next_state = (state & (a | b)) | (a & b);
assign q = next_state;

always @(posedge clk) begin
    state <= next_state;
end

endmodule