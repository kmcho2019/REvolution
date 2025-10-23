module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    reg [7:0] pos_edge_detect;

    always @(*) begin
        pos_edge_detect = (~prev_in) & in;
    end

    always @(posedge clk) begin
        pedge   <= pos_edge_detect;
        prev_in <= in;
    end

endmodule