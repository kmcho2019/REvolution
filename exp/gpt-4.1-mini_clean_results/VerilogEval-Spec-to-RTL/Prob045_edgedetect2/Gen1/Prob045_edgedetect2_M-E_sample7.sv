module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detect;

    always @(posedge clk) begin
        prev_in <= in;
        edge_detect <= in ^ prev_in;
        anyedge <= edge_detect;
    end

endmodule