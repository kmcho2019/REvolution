module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

always @(posedge clk) begin
    if (~a) state <= b;
    // No explicit else condition, as state should retain its value when 'a' is high
end

assign q = (~a)? b : ~state;

endmodule