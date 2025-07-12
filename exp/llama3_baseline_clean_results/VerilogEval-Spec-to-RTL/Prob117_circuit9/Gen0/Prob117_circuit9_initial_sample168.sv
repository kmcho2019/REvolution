module TopModule(clk, a, q);
    input clk, a;
    output [2:0] q;
    reg [2:0] q;

    always @(posedge clk) begin
        if (a == 0) begin
            if (q == 4) begin
                q <= 0;
            end
            else if (q == 0) begin
                q <= 1;
            end
            else begin
                q <= q + 1;
            end
        end
        else if (a == 1 && q == 0) begin
            q <= 4;
        end
    end
endmodule