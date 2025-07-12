module TopModule (
    input clk,
    input in,
    output out
);

    reg q;

    always @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;

endmodule