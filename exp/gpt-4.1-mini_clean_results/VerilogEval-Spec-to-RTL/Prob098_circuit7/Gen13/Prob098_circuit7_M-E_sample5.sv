module TopModule (
    input clk,
    input a,
    output q
);
    reg prev_a;

    always @(posedge clk) begin
        prev_a <= a;
    end

    assign q = ~(prev_a & a);

endmodule