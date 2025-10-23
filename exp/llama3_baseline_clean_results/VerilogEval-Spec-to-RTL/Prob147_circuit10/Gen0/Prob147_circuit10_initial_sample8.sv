module TopModule(clk, a, b, q, state);
    input clk, a, b;
    output q, state;
    reg state;

    always @(posedge clk) begin
        if (~b && ~a) begin
            state <= 1;
        end else if (b && a) begin
            state <= 0;
        end
    end

    assign q = (b && ~state) || (~b && state);
endmodule