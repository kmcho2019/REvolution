module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Sequential part: store previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational part: edge detection
    assign edge_detect = in ^ prev_in;

    // Sequential part: register output
    always @(posedge clk) begin
        anyedge <= edge_detect;
    end

endmodule