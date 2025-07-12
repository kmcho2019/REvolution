module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect = in ^ prev_in;

    always @(posedge clk) begin
        anyedge <= edge_detect;  // Edge detection result
        prev_in <= in;           // Store current input for next cycle
    end

endmodule