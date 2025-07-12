module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    // Sequential part: store previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinational part: detect edges
    assign anyedge = in ^ prev_in;

endmodule