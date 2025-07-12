module TopModule (
    input clk,
    input d,
    output reg q
);

    reg intermediate;

    always @(posedge clk) begin
        intermediate <= d;
        q <= intermediate;
    end

endmodule