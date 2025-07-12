module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;  // Stores input from previous cycle
    wire [7:0] edge_detect;  // Combinational edge detection

    // Combinational logic: detect edges using XOR
    assign edge_detect = in ^ prev_in;

    // Sequential logic: register updates
    always @(posedge clk) begin
        anyedge <= edge_detect;  // Register the edge detection
        prev_in <= in;           // Store current input for next cycle
    end

endmodule