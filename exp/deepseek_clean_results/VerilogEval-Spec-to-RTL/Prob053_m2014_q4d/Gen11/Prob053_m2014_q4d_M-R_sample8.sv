module TopModule (
    input clk,
    input in,
    output out
);

    reg dff;
    wire xor_out;

    assign xor_out = in ^ dff;
    assign out = dff;

    always @(posedge clk) begin
        dff <= xor_out;
    end

endmodule