module TopModule(clk, x, z);
    input clk;
    input x;
    output z;
    reg z;
    reg ff_x, ff_and, ff_or;

    always @(posedge clk) begin
        ff_x <= x ^ ff_x;
        ff_and <= x & ~ff_and;
        ff_or <= x | ~ff_or;
    end

    assign z = ~(ff_x | ff_and | ff_or);

    initial begin
        ff_x = 0;
        ff_and = 0;
        ff_or = 0;
    end
endmodule