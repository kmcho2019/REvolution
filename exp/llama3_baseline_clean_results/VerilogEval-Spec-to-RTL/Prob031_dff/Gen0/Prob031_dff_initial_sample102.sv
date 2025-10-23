module TopModule(
    input clk,  // clock
    input d,    // data input
    output reg q  // data output
);

always @(posedge clk) begin
    q <= d;  // on the positive edge of the clock, assign 'd' to 'q'
end

endmodule