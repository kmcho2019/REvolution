module TopModule (
    input clk,
    input in,
    output out
);

    reg dff_out;

    always @(posedge clk) begin
        dff_out <= in ^ dff_out;
    end

    assign out = dff_out;

endmodule