module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Implement the D flip-flop directly inside TopModule
    always @(posedge clk) begin
        q <= d;
    end
endmodule