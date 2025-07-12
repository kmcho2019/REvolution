module TopModule(
    input clk,  // clock
    input d,    // data
    output reg q  // output
);

always @(posedge clk) begin
    q <= d;  // on the positive edge of clk, capture 'd' and assign it to 'q'
end

endmodule