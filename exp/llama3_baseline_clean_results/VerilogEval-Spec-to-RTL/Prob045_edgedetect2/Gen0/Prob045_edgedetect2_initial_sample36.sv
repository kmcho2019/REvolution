module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    wire [7:0] prev_in;

    reg [7:0] prev_in_reg;

    always @(posedge clk) begin
        prev_in_reg <= in;
    end

    assign prev_in = prev_in_reg;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: edge_detector
            EdgeDetector edge_detector_i(
                .clk(clk),
                .in(in[i]),
                .prev_in(prev_in[i]),
                .anyedge(anyedge[i])
            );
        end
    endgenerate

endmodule

module EdgeDetector(
    input clk,
    input in,
    input prev_in,
    output reg anyedge
);

    always @(posedge clk) begin
        anyedge <= (in != prev_in) ? 1'b1 : 1'b0;
    end

endmodule