module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

always @ (posedge clk) begin
    if (a) begin
        q <= 4;
    end else begin
        q <= (q + 1) % 8;
    end
end

endmodule