module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] in_dly1, in_dly2;

    always @(posedge clk) begin
        in_dly1 <= in;
        in_dly2 <= in_dly1;
        anyedge <= in_dly1 ^ in_dly2;
    end

endmodule