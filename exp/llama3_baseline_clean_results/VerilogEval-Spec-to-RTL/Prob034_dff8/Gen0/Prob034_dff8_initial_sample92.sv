module DFF(clk, d, q);
    input clk, d;
    output q;
    reg q;

    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule(clk, d, q);
    input clk;
    input [7:0] d;
    output [7:0] q;
    reg [7:0] q;

    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            DFF dff(.clk(clk), .d(d[i]), .q(q[i]));
        end
    endgenerate
endmodule