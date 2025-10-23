module TopModule(clk, a, b, q, state);
    input clk;
    input a;
    input b;
    output q;
    output state;
    reg state;

    always @(posedge clk) begin
        if (~a & ~b) begin // set condition
            state <= 1;
        end else if (a & b) begin // reset condition
            state <= 0;
        end
    end

    assign q = (b & (a | state));
endmodule