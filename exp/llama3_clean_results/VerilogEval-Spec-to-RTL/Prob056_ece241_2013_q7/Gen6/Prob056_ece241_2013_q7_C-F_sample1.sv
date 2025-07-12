module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    if (j == 1'b0) begin
        Q <= (k == 1'b0)? Q : 1'b0;
    end else begin
        Q <= (k == 1'b0)? 1'b1 : ~Q;
    end
end

endmodule