module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

    wire next;
    assign next = r ? 1'b0 : d;

    always @(posedge clk) begin
        if (r || (next != q))
            q <= next;
    end

endmodule