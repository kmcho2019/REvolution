module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;  // Explicit 8-bit reset
    end
    else begin
        q <= d;     // Parallel vector assignment
    end
end

endmodule