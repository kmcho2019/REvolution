module TopModule(clk, d, q);
    input clk;
    input d;
    output q;

    reg q_ff1, q_ff2;
    reg prev_clk;

    always @(posedge clk) begin
        q_ff1 <= d;
        prev_clk <= 1'b1;
    end

    always @(negedge clk) begin
        q_ff2 <= d;
        prev_clk <= 1'b0;
    end

    always @(*) begin
        if (clk == 1'b1)
            q <= q_ff1;
        else
            q <= q_ff2;
    end
endmodule