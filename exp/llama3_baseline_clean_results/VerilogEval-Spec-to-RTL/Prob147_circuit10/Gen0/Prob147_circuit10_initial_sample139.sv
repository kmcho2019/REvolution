module TopModule(clk, a, b, q, state);
    input clk, a, b;
    output q, state;
    reg q, state;

    always @(posedge clk) begin
        if (~a & b) begin
            state <= 0;
            q <= 1;
        end
        else if (a & ~b) begin
            state <= 0;
            q <= 0;
        end
        else if (a & b) begin
            state <= q;
            q <= 0;
        end
        else begin
            state <= q;
            q <= q;
        end
    end

    assign state = q;

endmodule