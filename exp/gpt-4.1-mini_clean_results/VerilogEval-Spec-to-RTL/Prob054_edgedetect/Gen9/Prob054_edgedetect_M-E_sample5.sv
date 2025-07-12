module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in;
    wire [7:0] detected_edge;

    assign detected_edge = (~prev_in) & in;

    always @(posedge clk) begin
        prev_in <= in;
        pedge   <= detected_edge;
    end

endmodule