module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Store previous input value
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational edge detection
    assign edge_detect = in ^ prev_in;

    // Register the edge detection result
    always @(posedge clk) begin
        anyedge <= edge_detect;
    end

endmodule