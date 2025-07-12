module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Output combinational logic: output q selects a or b based on state
assign q = (a & ~state) | (b & state);

// Update state flip-flop on positive edge of clock
always @(posedge clk) begin
    state <= q;
end

endmodule