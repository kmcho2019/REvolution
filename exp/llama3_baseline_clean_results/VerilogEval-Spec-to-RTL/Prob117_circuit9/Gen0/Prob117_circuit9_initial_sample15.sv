module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (!a) begin
        if (q == 7) begin
            q <= 0;
        end else if (q == 0) begin
            q <= 1;
        end else begin
            q <= q + 1;
        end
    end else begin
        q <= 4;
    end
end

initial begin
    q <= 4;
end

endmodule