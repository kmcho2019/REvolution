module TopModule (
    input clk,
    input a,
    output reg q
);
    reg a_reg;

    // Sample 'a' at falling edge of clk
    always @(negedge clk) begin
        a_reg <= a;
    end

    // At rising edge, output inverse of sampled 'a'
    always @(posedge clk) begin
        q <= ~a_reg;
    end
endmodule