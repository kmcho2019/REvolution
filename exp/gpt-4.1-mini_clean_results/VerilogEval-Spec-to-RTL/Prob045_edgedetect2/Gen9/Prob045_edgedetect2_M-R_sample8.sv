module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    reg [7:0] in_dly;

    always @(posedge clk) begin
        in_dly <= in;
    end

    assign anyedge = in ^ in_dly;

endmodule