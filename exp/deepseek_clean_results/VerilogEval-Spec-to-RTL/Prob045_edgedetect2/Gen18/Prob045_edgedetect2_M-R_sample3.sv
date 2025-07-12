module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Combinational logic for edge detection
    assign edge_detect = in ^ prev_in;

    // Sequential logic
    always @(posedge clk) begin
        anyedge <= edge_detect;
        prev_in <= in;
    end

endmodule