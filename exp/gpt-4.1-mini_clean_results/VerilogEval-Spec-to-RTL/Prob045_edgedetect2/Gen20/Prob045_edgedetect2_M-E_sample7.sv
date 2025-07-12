module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_d1, in_d2;
    reg [7:0] edge_detect;

    always @(posedge clk) begin
        in_d1 <= in;
        in_d2 <= in_d1;

        edge_detect <= in_d1 ^ in_d2;  // Detect edges between cycle n-2 and n-1
        anyedge <= edge_detect;        // Output edge detection delayed by one cycle
    end
endmodule