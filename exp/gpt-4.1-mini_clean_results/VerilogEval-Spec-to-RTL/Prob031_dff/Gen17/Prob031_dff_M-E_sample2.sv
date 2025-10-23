module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Single D flip-flop: q follows d at posedge clk
    always @(posedge clk) begin
        q <= d;
    end
endmodule