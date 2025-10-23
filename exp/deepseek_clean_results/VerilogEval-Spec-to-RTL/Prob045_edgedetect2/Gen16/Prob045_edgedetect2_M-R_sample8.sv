module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;  // Stores input from previous cycle
    wire [7:0] edge_detect;  // Combinational edge detection

    // Combinational logic: detect edges using XOR
    assign edge_detect = in ^ prev_in;
    
    // Registered output
    reg [7:0] anyedge_reg;
    assign anyedge = anyedge_reg;

    always @(posedge clk) begin
        // Store edge detection result
        anyedge_reg <= edge_detect;
        // Store current input for next cycle
        prev_in <= in;
    end

endmodule