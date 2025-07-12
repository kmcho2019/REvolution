module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;  // edge detection: 1 if bit toggled
        prev_in <= in;            // store current input for next cycle comparison
    end
endmodule