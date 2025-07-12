module TopModule (
    input           clk,
    input           reset,
    input  [7:0]    d,
    output reg [7:0] q
);
    // Synchronous reset and data load on positive clock edge
    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else
            q <= d;
    end
endmodule