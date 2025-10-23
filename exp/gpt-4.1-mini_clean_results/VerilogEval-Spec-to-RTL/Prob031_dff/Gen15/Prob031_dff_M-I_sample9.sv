module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Single D flip-flop implemented directly in TopModule
    // Triggered on positive clock edge
    always @(posedge clk) begin
        q <= d;
    end
endmodule