module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] edge_detect;

    // Combinational edge detection
    assign edge_detect = in & ~prev_in;

    // Sequential update
    always @(posedge clk) begin
        prev_in <= in;
        pedge <= edge_detect;
    end

endmodule