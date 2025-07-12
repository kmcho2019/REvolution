module TopModule(
    input  clk,
    input  a,
    input  b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    state <= a ? ~state : (b ? ~state : state);
    q <= b && (~a || ~state);
end

endmodule