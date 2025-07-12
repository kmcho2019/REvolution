module TopModule (
    input  clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d;  // delayed input to hold previous cycle's input

    always @(posedge clk) begin
        in_d <= in;
        pedge <= (~in_d) & in;  // detect 0->1 transition between previous and current input
    end

endmodule