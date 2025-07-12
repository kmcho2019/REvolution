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
    wire ff_out;
    wire d;

    assign d = in ^ ff_out;  // XOR input and current flip-flop output

    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(ff_out)
    );

    assign out = ff_out;  // Output directly driven by flip-flop output

endmodule