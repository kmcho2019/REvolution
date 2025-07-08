module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;  // XOR detects difference between current and previous input
        prev_in <= in;            // Store current input for next cycle comparison
    end

endmodule