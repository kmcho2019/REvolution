module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (areset) begin
        q <= 0;
    end
    else begin
        q <= d;
    end
end

endmodule