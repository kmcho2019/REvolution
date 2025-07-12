module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

initial q = 4;

always @(posedge clk) begin
    if (a) begin
        q <= 4;
    end else begin
        if (q == 6) begin
            q <= 0;
        end else if (q == 7) begin
            // This state should not occur but added for completeness
            q <= 0;
        end else begin
            q <= q + 1;
        end
    end
end

endmodule