module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        edge_detected <= prev_in ^ in;  // detect edges
        prev_in <= in;                  // update previous input
        anyedge <= edge_detected;       // register output one cycle after detection
    end
endmodule