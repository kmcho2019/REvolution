module TopModule(clk, a, q);
    input clk;
    input a;
    output q;
    reg q;
    reg prev_a;

    initial begin
        prev_a = 0;
        q = 0;
    end

    always @(posedge clk) begin
        if (a == 0) begin
            q <= 1;
            prev_a <= a;
        end else if (prev_a == 1 && a == 1) begin
            q <= 0;
            prev_a <= a;
        end else begin
            prev_a <= a;
        end
    end
endmodule