module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Behavioral D flip-flop implemented directly
    always @(posedge clk) begin
        q <= d;
    end
endmodule