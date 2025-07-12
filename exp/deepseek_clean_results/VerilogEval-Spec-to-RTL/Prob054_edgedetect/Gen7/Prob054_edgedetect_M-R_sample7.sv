module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev;

    // Sequential part: store previous input
    always @(posedge clk) begin
        prev <= in;
    end

    // Combinational part: edge detection
    assign pedge = in & ~prev;

endmodule