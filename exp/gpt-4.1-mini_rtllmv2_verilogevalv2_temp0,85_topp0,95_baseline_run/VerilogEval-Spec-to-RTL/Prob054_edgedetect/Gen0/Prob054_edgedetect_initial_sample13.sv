module TopModule(
    input        clk,
    input  [7:0] in,
    output [7:0] pedge
);

    reg [7:0] in_d1;     // previous cycle input
    reg [7:0] edge_d;    // detected edge, delayed by one cycle

    always @(posedge clk) begin
        in_d1 <= in;
        edge_d <= (~in_d1) & in;  // detect rising edge: previous 0 and current 1
    end

    assign pedge = edge_d;

endmodule