module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Detect edges by XORing current and previous inputs
        anyedge <= in ^ prev_in;
        // Store current input for next comparison
        prev_in <= in;
    end

endmodule