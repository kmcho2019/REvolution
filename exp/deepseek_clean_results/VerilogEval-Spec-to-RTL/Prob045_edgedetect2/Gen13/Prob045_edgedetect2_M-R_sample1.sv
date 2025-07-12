module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Combinational logic for edge detection
    assign edge_detect = in ^ prev_in;

    // Sequential logic for registered output
    always @(posedge clk) begin
        prev_in <= in;          // Store current input
        anyedge <= edge_detect; // Registered output
    end

endmodule