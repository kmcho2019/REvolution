module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end else begin
        for (int i = 0; i < 8; i++) begin
            q[i] <= d[i];
        end
    end
end

endmodule