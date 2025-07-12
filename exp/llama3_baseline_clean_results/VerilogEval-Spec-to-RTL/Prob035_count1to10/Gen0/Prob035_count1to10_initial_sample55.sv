module TopModule(clk, reset, q);
    input clk, reset;
    output [3:0] q;
    reg [3:0] q;

    always @(posedge clk) begin
        if (reset) begin
            q <= 1;
        end else if (q == 10) begin
            q <= 1;
        end else begin
            q <= q + 1;
        end
    end
endmodule