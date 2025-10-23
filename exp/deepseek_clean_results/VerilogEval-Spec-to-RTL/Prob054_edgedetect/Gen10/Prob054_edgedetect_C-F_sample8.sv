module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect = in & ~prev_in;

    always @(posedge clk) begin
        pedge <= edge_detect;
        prev_in <= in;
    end

endmodule