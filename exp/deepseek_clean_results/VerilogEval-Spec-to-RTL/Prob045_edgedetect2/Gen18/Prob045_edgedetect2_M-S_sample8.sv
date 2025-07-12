module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    always @(posedge clk) begin
        anyedge <= in ^ anyedge;  // XOR current input with previous output
        anyedge <= in;            // Store current input (last assignment wins)
    end

endmodule