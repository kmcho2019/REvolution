module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect = in & ~prev_in;

    // Sequential storage of previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Continuous output assignment
    assign pedge = edge_detect;

endmodule