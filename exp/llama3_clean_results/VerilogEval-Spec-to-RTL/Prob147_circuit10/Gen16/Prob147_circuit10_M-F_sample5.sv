module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (~a) state <= b;
    // No else condition needed, as state should remain the same when a is high
end

assign q = (~a) ? b : ~state;

endmodule