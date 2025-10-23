module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);
    // Clock enable to reduce unnecessary toggling:
    wire clk_en = r | (q != d);

    always @(posedge clk) begin
        if (r)
            q <= 1'b0;
        else if (clk_en)
            q <= d;
    end
endmodule