module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

parameter WIDTH = 8;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= {WIDTH{1'b0}};  // Reset all bits to 0
    end
    else begin
        q <= d;              // Clock edge behavior
    end
end

endmodule