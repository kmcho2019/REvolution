module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (!a) begin
        q <= 1;
    end else if (q == 1) begin
        q <= 0;
    end
end

endmodule