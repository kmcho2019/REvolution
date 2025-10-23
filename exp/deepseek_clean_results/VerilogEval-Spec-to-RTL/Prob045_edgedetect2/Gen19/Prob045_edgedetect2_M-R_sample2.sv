module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;  // Stores previous cycle's input
    wire [7:0] edge_detect;  // Combinational edge detection

    // Combinational logic: detect edges using XOR
    assign edge_detect = in ^ prev_in;
    
    // Output register
    reg [7:0] anyedge_reg;
    assign anyedge = anyedge_reg;

    // Sequential logic: update registers
    always @(posedge clk) begin
        prev_in <= in;          // Store current input for next cycle
        anyedge_reg <= edge_detect;  // Register the edge detection result
    end

endmodule