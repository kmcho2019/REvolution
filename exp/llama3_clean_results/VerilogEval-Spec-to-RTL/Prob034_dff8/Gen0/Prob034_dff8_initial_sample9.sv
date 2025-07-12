module TopModule(clk, d, q);
    input clk;
    input [7:0] d;
    output [7:0] q;

    reg [7:0] q;

    always @(posedge clk) begin
        q <= d;
    end

endmodule