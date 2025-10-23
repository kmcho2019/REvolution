module TopModule(clk, d, q);
    input clk;
    input [7:0] d;
    output reg [7:0] q;

    always @(posedge clk) begin
        q <= {d, q[7:1]};
    end
endmodule