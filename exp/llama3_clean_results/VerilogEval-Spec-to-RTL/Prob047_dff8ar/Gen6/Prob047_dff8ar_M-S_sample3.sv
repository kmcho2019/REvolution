module TopModule(
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'd0;
    end else begin
        for (int i = 0; i < 8; i++) begin
            q[i] <= d[i];
        end
    end
end

endmodule