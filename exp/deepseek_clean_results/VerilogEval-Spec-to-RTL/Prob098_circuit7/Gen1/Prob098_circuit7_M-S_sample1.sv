module TopModule (
    input clk,
    input a,
    output reg q
);

    reg seen_a = 0;

    always @(posedge clk) begin
        if (!seen_a) begin
            seen_a <= a;
            q <= 1;
        end else begin
            q <= 0;
        end
    end

endmodule