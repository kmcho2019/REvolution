module TopModule(clk, a, b, q, state);
    input clk;
    input a;
    input b;
    output q;
    output state;

    reg state_reg;
    assign state = state_reg;

    always @(posedge clk) begin
        if (~b) begin
            state_reg <= 0;
        end else if (state_reg == 0) begin
            state_reg <= ~a;
        end else begin
            state_reg <= 1;
        end
    end

    assign q = (state_reg == 1) || (b && ~state_reg && ~a);
endmodule