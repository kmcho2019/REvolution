module DFF(clk, reset, d, q);
    input clk, reset;
    input [7:0] d;
    output [7:0] q;
    reg [7:0] q;

    always @(negedge clk)
    begin
        if (reset)
            q <= 8'd52; // 0x34 in decimal is 52
        else
            q <= d;
    end
endmodule

module TopModule(clk, reset, d, q);
    input clk, reset;
    input [7:0] d;
    output [7:0] q;

    DFF DFF_inst(
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule