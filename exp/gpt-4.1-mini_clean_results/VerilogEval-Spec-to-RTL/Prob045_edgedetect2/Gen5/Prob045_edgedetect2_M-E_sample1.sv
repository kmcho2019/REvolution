module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] delay1, delay2;

    always @(posedge clk) begin
        delay2 <= delay1;
        delay1 <= in;
        anyedge <= delay1 ^ delay2;  // edge detected one cycle earlier than delay1
    end
endmodule