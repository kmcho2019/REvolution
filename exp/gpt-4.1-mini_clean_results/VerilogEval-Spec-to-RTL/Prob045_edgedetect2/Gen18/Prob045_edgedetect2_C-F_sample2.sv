module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= in ^ prev_in; // Registered edge detection output with one cycle delay
        prev_in <= in;           // Store current input for next comparison
    end
endmodule