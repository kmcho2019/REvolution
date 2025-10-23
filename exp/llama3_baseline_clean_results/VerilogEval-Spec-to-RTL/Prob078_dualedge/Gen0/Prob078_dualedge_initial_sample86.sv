module TopModule(clk, d, q);
    input clk;
    input d;
    output q;
    reg q;
    reg q_rising, q_falling;

    always @(posedge clk) begin
        q_rising <= d;
    end

    always @(negedge clk) begin
        q_falling <= d;
    end

    always @(posedge clk or negedge clk) begin
        if(clk) begin
            q <= q_rising;
        end else begin
            q <= q_falling;
        end
    end
endmodule