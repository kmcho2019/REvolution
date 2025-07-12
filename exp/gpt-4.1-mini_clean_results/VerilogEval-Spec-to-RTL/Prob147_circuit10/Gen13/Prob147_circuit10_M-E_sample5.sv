module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Combinational next state logic
wire next_state = (b & (a ^ state)) | (state & ~b);

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

endmodule