module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        edge_detected <= in ^ prev_in;  // detect edges comparing current and previous
        prev_in <= in;
        anyedge <= edge_detected;       // output one cycle delayed
    end
endmodule