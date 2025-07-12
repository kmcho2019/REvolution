module TopModule (
    input clk,
    input in,
    output out
);

    reg d_out = 1'b0;
    wire feedback_xor = in ^ d_out;

    always @(posedge clk) begin
        d_out <= feedback_xor;
    end

    assign out = d_out;

endmodule