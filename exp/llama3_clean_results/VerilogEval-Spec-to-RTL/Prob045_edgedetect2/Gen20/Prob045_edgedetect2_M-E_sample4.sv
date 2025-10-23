module EdgeDetector (
    input clk,
    input in,
    output reg edge
);

reg prev_in;

always @(posedge clk) begin
    edge <= in ^ prev_in;
    prev_in <= in;
end

endmodule

module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

generate
    for (genvar i = 0; i < 8; i++) begin : edge_gen
        EdgeDetector edge_detector (
            .clk(clk),
            .in(in[i]),
            .edge(anyedge[i])
        );
    end
endgenerate

endmodule