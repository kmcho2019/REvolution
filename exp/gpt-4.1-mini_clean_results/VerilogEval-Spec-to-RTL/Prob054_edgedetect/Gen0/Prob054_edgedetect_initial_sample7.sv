module TopModule (
    input  clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d;       // delayed input to hold previous cycle's input
    reg [7:0] detect;     // internal register for detection result

    always @(posedge clk) begin
        in_d <= in;
        detect <= (~in_d) & in;  // 0->1 transition detection on current cycle
        pedge <= detect;         // output registered one cycle after detection
    end

endmodule