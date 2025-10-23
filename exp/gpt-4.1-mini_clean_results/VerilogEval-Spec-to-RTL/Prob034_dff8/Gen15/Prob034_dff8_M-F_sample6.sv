module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (d != q)
            q <= d;
    end

endmodule