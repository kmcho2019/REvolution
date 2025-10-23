module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

always @(posedge clk) begin
    if (~a) state <= b;
end

assign q = (a) ? ~state : b;

endmodule