module TopModule(
    input clk,  // clock signal
    input d,   // input to the D flip-flop
    output reg q  // output of the D flip-flop
);

always @(posedge clk) begin
    q <= d;  // at positive edge of clock, store 'd' in 'q'
end

endmodule