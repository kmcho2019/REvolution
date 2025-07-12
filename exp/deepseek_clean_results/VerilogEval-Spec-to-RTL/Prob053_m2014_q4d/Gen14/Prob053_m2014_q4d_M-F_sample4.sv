module TopModule (
    input clk,
    input in,
    output out
);

    reg d_out;
    wire d_input = in ^ d_out;

    always @(posedge clk) begin
        d_out <= d_input;
    end

    assign out = d_out;

endmodule