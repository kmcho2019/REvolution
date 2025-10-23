module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    always @(posedge clk) prev_in <= in;
    assign pedge = in & ~prev_in;

endmodule