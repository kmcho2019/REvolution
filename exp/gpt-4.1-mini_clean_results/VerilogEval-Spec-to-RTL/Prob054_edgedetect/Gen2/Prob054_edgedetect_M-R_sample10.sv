module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d;          // holds previous cycle input
    wire [7:0] edge_detect;  // combinational 0->1 edge detection

    // Register previous input
    always @(posedge clk) begin
        in_d <= in;
    end

    // Combinational edge detection logic
    assign edge_detect = (~in_d) & in;

    // Register the edge detection to generate output pulse delayed by one cycle
    always @(posedge clk) begin
        pedge <= edge_detect;
    end

endmodule