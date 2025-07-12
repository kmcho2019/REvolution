module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

reg enable;
reg [7:0] d_prev;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 8'b0;
        enable <= 1'b0;
        d_prev <= 8'b0;
    end else begin
        d_prev <= d;
        enable <= (d != d_prev); // Enable only when data changes
        if (enable) begin
            q <= d;
        end
    end
end

endmodule