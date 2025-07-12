module TopModule(
    input clk,
    input d,
    output reg q
);

// Basic D flip-flop functionality: store 'd' at the positive edge of 'clk' and output as 'q'
always @(posedge clk) begin
    q <= d;
end

endmodule