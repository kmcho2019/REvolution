module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        prev_in <= in;
        edge_detected <= (~prev_in) & in;  // Detect 0->1 transitions on bits of 'in'
        pedge <= edge_detected;             // Output pedge one cycle after detection
    end

endmodule