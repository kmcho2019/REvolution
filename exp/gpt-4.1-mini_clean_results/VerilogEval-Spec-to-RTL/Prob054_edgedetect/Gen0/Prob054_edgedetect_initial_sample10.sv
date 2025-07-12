module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);
    reg [7:0] in_dly;
    reg [7:0] detected;

    always @(posedge clk) begin
        // Detect 0->1 transitions on current cycle
        detected <= (~in_dly) & in;
        // Output pedge is the detected signals delayed by 1 cycle
        pedge <= detected;
        // Store current input for next cycle
        in_dly <= in;
    end
endmodule