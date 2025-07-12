module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);
    reg [7:0] d_prev;

    always @(posedge clk) begin
        if (d != d_prev) begin
            q <= d;
        end
        d_prev <= d;
    end
endmodule