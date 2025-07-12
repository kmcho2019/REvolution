module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] pos_edge_detect;

    // Detect rising edges combinationally
    assign pos_edge_detect = (~prev_in) & in;

    // Register previous input
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Register the positive edge output one cycle after detection
    always @(posedge clk) begin
        pedge <= pos_edge_detect;
    end

endmodule