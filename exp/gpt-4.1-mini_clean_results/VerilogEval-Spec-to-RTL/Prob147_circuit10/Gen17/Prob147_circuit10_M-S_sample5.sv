module TopModule (
    input clk,
    input a,    // unused in simplified version
    input b,
    output reg state,
    output q
);

always @(posedge clk) begin
    state <= b;
end

assign q = state;

endmodule