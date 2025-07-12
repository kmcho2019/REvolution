module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    reg [7:0] anyedge_next;

    always @(posedge clk) begin
        // Detect edges by XORing current input with previous stored input
        anyedge_next <= in ^ prev_in;
        prev_in <= in;
        // Output the detected edges one cycle after detection
        anyedge <= anyedge_next;
    end
endmodule