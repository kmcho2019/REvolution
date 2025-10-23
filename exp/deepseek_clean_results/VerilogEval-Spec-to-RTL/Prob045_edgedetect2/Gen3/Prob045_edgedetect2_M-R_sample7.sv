module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Combinational logic for edge detection
    assign edge_detect = in ^ prev_in;

    // Sequential logic for storing previous input and output
    always @(posedge clk) begin
        prev_in <= in;
        anyedge <= edge_detect;
    end

endmodule