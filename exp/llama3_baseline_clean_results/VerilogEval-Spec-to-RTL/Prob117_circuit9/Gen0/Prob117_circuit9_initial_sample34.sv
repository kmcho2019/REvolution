module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (~a) begin
        if (q == 3'd6) begin
            q <= 3'd0;
        end else begin
            q <= q + 1;
        end
    end else begin
        q <= q;
    end
end

endmodule