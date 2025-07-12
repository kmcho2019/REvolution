module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edges;

    assign edges = in ^ prev_in;

    always @(posedge clk) begin
        prev_in <= in;
        anyedge <= edges;
    end
endmodule