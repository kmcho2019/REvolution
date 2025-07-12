module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q;
    end
    else begin
        if (q == 1'bx) q <= 1; // initialization
    end
end

endmodule