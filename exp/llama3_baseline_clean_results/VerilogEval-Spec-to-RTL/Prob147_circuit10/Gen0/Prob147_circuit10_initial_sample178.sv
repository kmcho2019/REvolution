module TopModule(clk, a, b, q, state);
    input clk, a, b;
    output q, state;
    reg state;

    always @(posedge clk) begin
        if (~a & ~b) begin
            state <= 1'b1;
        end else if (a & b) begin
            state <= 1'b0;
        end
    end

    assign q = (~state & b);

endmodule