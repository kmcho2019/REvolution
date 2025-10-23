module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (~a) begin
        q <= 1;
    end else if (a) begin
        if (~q) begin
            q <= 0;
        end else begin
            q <= 0;
        end
    end
end

endmodule