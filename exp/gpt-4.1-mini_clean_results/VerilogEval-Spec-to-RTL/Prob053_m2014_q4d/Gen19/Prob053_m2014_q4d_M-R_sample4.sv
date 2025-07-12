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

    wire d;
    wire q;

    assign d = in ^ q;

    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );

    assign out = q;

endmodule