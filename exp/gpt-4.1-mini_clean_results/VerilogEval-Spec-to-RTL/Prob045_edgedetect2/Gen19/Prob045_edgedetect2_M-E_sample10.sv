module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;  // Detect edges comparing current input with previous
        prev_in <= in;            // Save current input for next comparison
    end
endmodule