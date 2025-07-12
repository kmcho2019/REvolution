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
    input [7:0] d,
    output [7:0] q
);
    DFF dffs[7:0] (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule