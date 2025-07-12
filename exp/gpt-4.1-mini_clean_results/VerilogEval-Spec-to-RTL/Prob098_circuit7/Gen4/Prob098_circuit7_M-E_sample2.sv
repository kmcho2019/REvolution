module TopModule (
    input clk,
    input a,
    output reg q
);
    wire t;
    assign t = a ^ q; // toggle if a differs from q

    always @(posedge clk) begin
        if (t)
            q <= ~q;
        else
            q <= q;
    end
endmodule