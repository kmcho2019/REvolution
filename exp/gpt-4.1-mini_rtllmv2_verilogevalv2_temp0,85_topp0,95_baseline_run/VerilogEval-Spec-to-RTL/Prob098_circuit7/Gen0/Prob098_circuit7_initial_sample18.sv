module TopModule(input clk, input a, output reg q);
    reg a_d; // delayed a

    always @(posedge clk) begin
        a_d <= a; // store previous a
        if (a == 0)
            q <= 1'b1;
        else if (a == 1 && a_d == 1)
            q <= 1'b0;
        // else retain q
    end
endmodule