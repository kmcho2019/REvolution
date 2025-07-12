module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 0;         // Asynchronous reset all bits to 0
    end
    else begin
        q <= d;         // Parallel assignment on clock edge
    end
end

endmodule