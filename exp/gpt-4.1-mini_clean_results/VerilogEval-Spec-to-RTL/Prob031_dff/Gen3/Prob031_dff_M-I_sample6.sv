module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    wire d_changed = (d != q);

    always @(posedge clk) begin
        if (d_changed)
            q <= d;
    end
endmodule