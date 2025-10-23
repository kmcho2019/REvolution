module TopModule (
    input clk,
    input in,
    output out
);

    reg d_out;

    always @(posedge clk) begin
        d_out <= in ^ d_out;
    end

    assign out = d_out;

endmodule