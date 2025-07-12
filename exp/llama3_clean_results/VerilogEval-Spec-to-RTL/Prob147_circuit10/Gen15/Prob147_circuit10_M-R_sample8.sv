module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (~a) state <= b;
    else state <= state;
end

assign q = (~a) ? b : (~state ? b : ~b);

endmodule