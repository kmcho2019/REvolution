module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] pedge_wire = in & ~prev_in;

    always @(posedge clk) begin
        prev_in <= in;
    end

    assign pedge = pedge_wire;

endmodule