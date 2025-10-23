module TopModule (
    input clk,
    input a,
    output q
);

    reg seen_a = 1'b0;

    always @(posedge clk) begin
        if (a) begin
            seen_a <= 1'b1;
        end
    end

    assign q = ~seen_a;

endmodule