module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d1;  // input delayed by one clock cycle
    reg [7:0] in_d2;  // input delayed by two clock cycles

    always @(posedge clk) begin
        in_d1 <= in;
        in_d2 <= in_d1;

        // pedge is asserted one clock cycle after a 0->1 transition from in_d2 to in_d1
        pedge <= (~in_d2) & in_d1;
    end

endmodule