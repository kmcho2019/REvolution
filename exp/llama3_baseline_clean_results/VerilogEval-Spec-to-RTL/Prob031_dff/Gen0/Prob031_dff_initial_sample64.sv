module TopModule(
    input  clk,  // clock input
    input  d,   // data input
    output reg q  // output of the flip-flop
);

always_ff @(posedge clk) begin
    q <= d;
end

endmodule