module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Combinational edge detection
    assign edge_detect = in ^ prev_in;

    // Sequential logic
    always @(posedge clk) begin
        prev_in <= in;          // Store current input
        anyedge <= edge_detect;  // Register edge detection result
    end

endmodule