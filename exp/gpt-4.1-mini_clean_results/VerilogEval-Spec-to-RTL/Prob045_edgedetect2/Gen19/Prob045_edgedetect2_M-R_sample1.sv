module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Detect edges by XOR of current and previous input
    assign edge_detect = in ^ prev_in;

    // Register previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Register edge detection result with one cycle delay
    always @(posedge clk) begin
        anyedge <= edge_detect;
    end
endmodule