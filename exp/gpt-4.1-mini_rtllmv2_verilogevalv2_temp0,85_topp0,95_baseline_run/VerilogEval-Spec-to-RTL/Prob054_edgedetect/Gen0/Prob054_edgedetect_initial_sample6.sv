module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d; // delayed version of input

    always @(posedge clk) begin
        // Detect positive edges by checking where previous input bit was 0 and current is 1
        pedge <= (~in_d) & in;
        // Update delayed input
        in_d <= in;
    end

endmodule