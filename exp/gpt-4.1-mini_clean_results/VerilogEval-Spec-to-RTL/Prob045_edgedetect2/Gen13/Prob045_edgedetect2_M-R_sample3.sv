module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;

    wire [7:0] edges = in ^ prev_in;  // combinational edge detection

    always @(posedge clk) begin
        anyedge <= edges;   // register the detected edges, one cycle delayed
        prev_in <= in;      // store current input for next cycle comparison
    end
endmodule