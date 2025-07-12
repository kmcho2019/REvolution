module TopModule(clk, a, b, q, state);
    input clk, a, b;
    output q, state;
    reg state;

    always @(posedge clk) begin
        if (a == 0 && b == 1) begin
            state <= 1;
        end else if (state == 0 && a == 1 && b == 0) begin
            state <= 1;
        end else if (state == 1 && a == 1 && b == 1) begin
            state <= 0;
        end
    end

    assign q = (state == 0 && b == 1) || (state == 1 && a == 1 && b == 1);
endmodule