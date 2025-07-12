module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Combinational XOR between current input and previous input to detect edges
    assign edge_detect = in ^ prev_in;

    always @(posedge clk) begin
        prev_in <= in;          // Store current input for next cycle comparison
        anyedge <= edge_detect; // Register edge detection output (1 cycle delayed)
    end
endmodule