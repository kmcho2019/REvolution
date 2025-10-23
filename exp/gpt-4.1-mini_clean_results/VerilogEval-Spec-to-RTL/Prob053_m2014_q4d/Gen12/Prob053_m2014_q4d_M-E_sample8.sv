module TopModule (
    input clk,
    input in,
    output reg out
);

    reg intermediate;

    wire d;
    assign d = in ^ intermediate;

    always @(posedge clk) begin
        intermediate <= out;
        out <= d;
    end

endmodule