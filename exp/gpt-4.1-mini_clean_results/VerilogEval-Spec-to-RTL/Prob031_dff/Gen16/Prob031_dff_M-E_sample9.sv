module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Sequential logic: D flip-flop triggered on positive edge of clk
    always @(posedge clk) begin
        q <= d;
    end
endmodule