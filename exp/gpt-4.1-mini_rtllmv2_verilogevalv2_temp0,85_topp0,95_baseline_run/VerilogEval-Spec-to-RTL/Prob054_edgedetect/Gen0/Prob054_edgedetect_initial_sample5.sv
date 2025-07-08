module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_dly;      // stores previous input
    reg [7:0] posedge_detected; // stores detection before output

    always @(posedge clk) begin
        in_dly <= in;
        posedge_detected <= (~in_dly) & in;   // detect 0->1 transition for each bit
        pedge <= posedge_detected;            // output detection delayed by 1 cycle
    end

endmodule