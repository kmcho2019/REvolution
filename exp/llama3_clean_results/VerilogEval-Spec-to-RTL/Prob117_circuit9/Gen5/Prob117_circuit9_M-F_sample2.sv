module TopModule(clk, a, q);
    input clk, a;
    output [2:0] q;

    reg [2:0] q;
    reg init_q;

    initial begin
        init_q = 0;
    end

    always @(posedge clk) begin
        if (a &&!init_q) begin
            q <= 4;
            init_q <= 1;
        end else if (!a) begin
            if (q == 7) begin
                q <= 0;
            end else begin
                q <= q + 1;
            end
        end
    end
endmodule