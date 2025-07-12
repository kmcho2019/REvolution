module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Combinational logic: edge detection
    assign edge_detect = in ^ prev_in;

    // Sequential logic: register updates
    always @(posedge clk) begin
        prev_in <= in;
        anyedge <= edge_detect;
    end

endmodule