module TopModule (
    input         clk,
    input  [7:0]  in,
    output reg [7:0] pedge
);

    reg [7:0] in_d;
    reg [7:0] edge_detect;

    // Register the previous input value
    always @(posedge clk) begin
        in_d <= in;
    end

    // Combinationally detect 0-to-1 transitions using previous and current inputs
    always @(*) begin
        edge_detect = (~in_d) & in;
    end

    // Register the edge_detect output to delay pedge by one clock cycle
    always @(posedge clk) begin
        pedge <= edge_detect;
    end

endmodule