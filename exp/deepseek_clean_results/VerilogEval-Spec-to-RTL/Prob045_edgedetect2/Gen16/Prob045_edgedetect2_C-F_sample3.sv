module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    parameter WIDTH = 8;  // Configurable bus width
    reg [WIDTH-1:0] prev_in;  // Stores previous input values

    always @(posedge clk) begin
        // Edge detection: XOR current and previous inputs
        anyedge <= in ^ prev_in;
        // Update history register
        prev_in <= in;
    end

endmodule