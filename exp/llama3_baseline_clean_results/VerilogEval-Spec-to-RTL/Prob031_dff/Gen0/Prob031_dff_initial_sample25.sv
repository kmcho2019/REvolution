module TopModule(
    input clk,  // Clock signal
    input d,   // Data input
    output reg q  // Data output
);

always @(posedge clk) begin
    q <= d;
end

endmodule