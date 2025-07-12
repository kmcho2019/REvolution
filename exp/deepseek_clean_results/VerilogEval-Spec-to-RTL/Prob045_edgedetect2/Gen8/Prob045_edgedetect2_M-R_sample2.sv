module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    wire [7:0] anyedge_wire = in ^ prev_in;

    assign anyedge = anyedge_wire;

    always @(posedge clk) begin
        prev_in <= in;
    end

endmodule