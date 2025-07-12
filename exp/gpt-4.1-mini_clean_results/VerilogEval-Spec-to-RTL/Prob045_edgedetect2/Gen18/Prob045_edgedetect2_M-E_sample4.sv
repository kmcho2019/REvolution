module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Compute edges by XORing current input with previous input
    assign edge_detect = in ^ prev_in;

    always @(posedge clk) begin
        prev_in <= in;
        anyedge <= edge_detect;  // Output edge detection delayed by one clock cycle
    end
endmodule