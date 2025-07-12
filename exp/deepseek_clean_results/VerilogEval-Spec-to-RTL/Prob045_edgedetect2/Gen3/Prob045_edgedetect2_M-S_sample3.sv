module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    always @(posedge clk) begin
        anyedge <= in ^ anyedge;  // Use anyedge to store previous in via XOR
    end

endmodule