module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_d1, in_d2;

    always @(posedge clk) begin
        in_d1 <= in;           // Latch current input
        in_d2 <= in_d1;        // Latch previous input
        anyedge <= in_d1 ^ in_d2;  // Edge detected one cycle after transition
    end
endmodule