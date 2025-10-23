module TopModule(
    input clk,  // clock signal
    input d,    // input data
    output reg q  // output data
);

always @(posedge clk) begin
    q <= d;  // capture input 'd' on the positive edge of 'clk'
end

endmodule