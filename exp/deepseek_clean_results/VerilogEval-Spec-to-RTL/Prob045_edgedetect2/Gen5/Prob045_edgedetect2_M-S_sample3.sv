module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] in_delayed;

    always @(posedge clk) begin
        anyedge <= in ^ in_delayed;
        in_delayed <= in;
    end

endmodule