module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input in,
    output out
);
    wire xor_out;
    wire dff_out;

    assign xor_out = in ^ dff_out;

    DFF dff_inst (
        .clk(clk),
        .d(xor_out),
        .q(dff_out)
    );

    assign out = dff_out;

endmodule