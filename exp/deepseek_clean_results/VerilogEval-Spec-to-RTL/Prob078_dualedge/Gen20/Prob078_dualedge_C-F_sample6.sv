module TopModule (
    input clk,
    input d,
    output reg q
);

    reg p, n;

    always @(posedge clk) p <= d;
    always @(negedge clk) n <= d;

    always @(posedge clk, negedge clk) begin
        q <= clk ? p : n;
    end

endmodule