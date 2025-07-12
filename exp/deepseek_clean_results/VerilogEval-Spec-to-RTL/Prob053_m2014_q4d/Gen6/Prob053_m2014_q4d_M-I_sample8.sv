module TopModule (
    input clk,
    input in,
    output out
);

    reg dff_out;
    wire xor_out;

    assign xor_out = in ^ dff_out;
    assign out = dff_out;

    always @(posedge clk) begin
        dff_out <= xor_out;
    end

endmodule