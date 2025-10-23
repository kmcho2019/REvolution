module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect = in & ~prev_in;  // Positive edge detection

    always @(posedge clk) begin
        prev_in <= in;       // Store current input for next cycle
        pedge <= edge_detect; // Output edge detection result
    end

endmodule