module TopModule(clk, d, q);
    input clk;
    input d;
    output q;

    reg q_rising;
    reg q_falling;
    reg prev_clk;

    initial begin
        q_rising = 0;
        q_falling = 0;
        prev_clk = 0;
    end

    always @(posedge clk) begin
        q_rising <= d;
    end

    always @(negedge clk) begin
        q_falling <= d;
    end

    always @(posedge clk or negedge clk) begin
        if (clk != prev_clk) begin
            prev_clk <= clk;
            if (clk == 1'b1) begin
                q <= q_rising;
            end else begin
                q <= q_falling;
            end
        end
    end
endmodule