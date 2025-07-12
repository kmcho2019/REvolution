module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    parameter WIDTH = 8;  // Configurable bus width
    reg [WIDTH-1:0] prev_in;  // Stores previous cycle's input

    always @(posedge clk) begin
        // Any edge detection: 1 when input changed from last cycle
        anyedge <= in ^ prev_in;
        // Store current input for next cycle comparison
        prev_in <= in;
    end

endmodule