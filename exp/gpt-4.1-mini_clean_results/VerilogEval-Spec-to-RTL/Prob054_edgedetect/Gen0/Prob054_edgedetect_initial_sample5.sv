module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] in_d;        // delayed input to hold previous value
reg [7:0] detected;    // register to hold detected 0->1 transitions

always @(posedge clk) begin
    in_d <= in;
    detected <= (~in_d) & in;  // detect 0->1 transitions
    pedge <= detected;         // output the detected signal next cycle
end

endmodule