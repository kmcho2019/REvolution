module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end
    else begin
        // Rotate right implementation with parallel load
        q <= {d[0], d[7:1]};
    end
end

endmodule