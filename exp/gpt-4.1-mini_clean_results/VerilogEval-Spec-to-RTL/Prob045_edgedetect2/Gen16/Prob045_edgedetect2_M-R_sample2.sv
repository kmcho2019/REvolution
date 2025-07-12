module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Register the previous input on clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinationally detect edges between current and previous input
    assign edge_detect = in ^ prev_in;

    // Register the edge detection result, delayed by one clock cycle
    always @(posedge clk) begin
        anyedge <= edge_detect;
    end
endmodule