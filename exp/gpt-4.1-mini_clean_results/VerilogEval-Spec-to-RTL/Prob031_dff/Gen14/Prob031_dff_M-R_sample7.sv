module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Synchronous D flip-flop behavior directly in TopModule
    always @(posedge clk) begin
        q <= d;
    end
endmodule