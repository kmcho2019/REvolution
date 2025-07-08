module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        prev_in <= in;
        edge_detected <= (~prev_in) & in;  // detect 0->1 transitions
        pedge <= edge_detected;            // output the detection on next cycle
    end

endmodule