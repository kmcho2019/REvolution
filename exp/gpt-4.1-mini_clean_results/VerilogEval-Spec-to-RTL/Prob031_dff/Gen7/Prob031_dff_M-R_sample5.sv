module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Positive-edge triggered D flip-flop directly implemented in TopModule
    always @(posedge clk) begin
        q <= d;
    end
endmodule