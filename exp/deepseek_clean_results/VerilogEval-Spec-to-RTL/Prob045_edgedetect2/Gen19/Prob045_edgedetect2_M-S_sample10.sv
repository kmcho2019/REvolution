module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;  // Stores input from previous cycle

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;  // Direct edge detection and assignment
        prev_in <= in;            // Store current input for next cycle
    end

endmodule