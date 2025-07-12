module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    parameter WIDTH = 8;
    reg [WIDTH-1:0] prev_in;
    wire [WIDTH-1:0] pedge_comb;

    // Sequential part: store previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational part: detect positive edges
    assign pedge_comb = in & ~prev_in;

    // Sequential part: register the output
    always @(posedge clk) begin
        pedge <= pedge_comb;
    end

endmodule