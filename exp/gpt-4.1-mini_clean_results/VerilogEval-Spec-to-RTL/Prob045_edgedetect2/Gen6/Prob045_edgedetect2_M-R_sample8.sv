module TopModule (
    input clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Register previous input on clock edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational edge detection between current and previous input
    assign edge_detect = in ^ prev_in;

    // Register edge_detect to produce anyedge with one cycle delay
    always @(posedge clk) begin
        anyedge <= edge_detect;
    end

endmodule