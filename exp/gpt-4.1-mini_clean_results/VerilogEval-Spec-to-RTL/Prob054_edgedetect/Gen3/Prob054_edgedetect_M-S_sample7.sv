module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d;  // holds previous cycle input

    always @(posedge clk) begin
        pedge <= (~in_d) & in; // detect 0->1 transition from last cycle
        in_d <= in;            // update previous input
    end

endmodule