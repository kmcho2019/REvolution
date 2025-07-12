module TopModule(clk, a, q);
    input clk;
    input a;
    output [2:0] q;
    reg [2:0] q;

    always @(posedge clk or a)
    begin
        if (a)
        begin
            q <= 4'd4;
        end
        else
        begin
            q <= q + 1'd1;
            if (q == 4'd7) 
                q <= 4'd0;
        end
    end
endmodule