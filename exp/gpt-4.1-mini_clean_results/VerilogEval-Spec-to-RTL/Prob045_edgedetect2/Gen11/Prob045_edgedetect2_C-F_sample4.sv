module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Combinational edge detection between current and previous input
    assign edge_detect = in ^ prev_in;

    // Register previous input and anyedge on clock edge
    always @(posedge clk) begin
        anyedge <= edge_detect;
        prev_in <= in;
    end

endmodule