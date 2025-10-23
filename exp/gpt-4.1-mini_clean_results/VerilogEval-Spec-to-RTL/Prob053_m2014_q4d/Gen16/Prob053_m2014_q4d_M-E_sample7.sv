module TopModule (
    input clk,
    input in,
    output out
);

    reg q;
    wire d;

    assign out = q;
    assign d = in ^ q;

    always @(posedge clk) begin
        q <= d;
    end

endmodule