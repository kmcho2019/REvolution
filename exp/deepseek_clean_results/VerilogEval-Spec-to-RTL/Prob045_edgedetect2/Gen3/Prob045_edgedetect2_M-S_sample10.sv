module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    always @(posedge clk) begin
        anyedge <= in ^ anyedge;  // Edge detection using previous anyedge as storage
        anyedge <= in;            // Store current input for next cycle
    end

endmodule