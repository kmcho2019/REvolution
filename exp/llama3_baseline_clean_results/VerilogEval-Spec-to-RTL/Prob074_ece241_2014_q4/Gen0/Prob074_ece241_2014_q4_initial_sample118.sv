module TopModule(clk, x, z);
    input clk, x;
    output z;
    reg q1, q2, q3;

    assign z = ~(q1 | q2 | q3);

    always @(posedge clk) begin
        q1 <= x ^ q1;
        q2 <= x & ~q2;
        q3 <= x | ~q3;
    end

    initial begin
        q1 = 0;
        q2 = 0;
        q3 = 0;
    end
endmodule