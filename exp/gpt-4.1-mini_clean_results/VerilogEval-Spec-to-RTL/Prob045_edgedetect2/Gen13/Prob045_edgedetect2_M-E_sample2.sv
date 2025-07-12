module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_d1;  // input delayed by 1 clock
    reg [7:0] in_d2;  // input delayed by 2 clocks

    always @(posedge clk) begin
        in_d1 <= in;
        in_d2 <= in_d1;
        anyedge <= in_d1 ^ in_d2; // any edge detected between the last two input samples, output delayed by one cycle
    end
endmodule