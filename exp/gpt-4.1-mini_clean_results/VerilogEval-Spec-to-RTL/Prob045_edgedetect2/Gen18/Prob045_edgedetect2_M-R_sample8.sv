module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    reg [7:0] edge_detect;

    always @(posedge clk) begin
        edge_detect <= in ^ prev_in;  // Detect edges: 1 where bits changed
        prev_in <= in;                // Store current input for next cycle comparison
        anyedge <= edge_detect;       // Output the edge detection delayed by one cycle
    end
endmodule