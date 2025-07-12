module right_shifter(clk, d, q);
    input clk;
    input d;
    output [7:0] q;

    reg [7:0] q;

    initial
        q = 8'b0;

    always @(posedge clk)
    begin
        q = {d, q[7:1]};
    end
endmodule