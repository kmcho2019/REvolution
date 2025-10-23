module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= 0;
    end else begin
        if (q == 1'b1) begin
            q <= 1;
        end else if (q == 1'b0) begin
            q <= 1;
        end
    end
end

endmodule