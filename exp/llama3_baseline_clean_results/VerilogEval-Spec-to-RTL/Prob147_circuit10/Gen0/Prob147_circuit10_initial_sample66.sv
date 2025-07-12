module TopModule(clk, a, b, q, state);
    input clk;
    input a;
    input b;
    output q;
    output state;
    reg state;

    always @(posedge clk) begin
        if (b && !state) begin
            state <= 1'b1;
        end else if (!a && !b && state) begin
            state <= 1'b0;
        end
    end

    assign q = (b || !a);
endmodule