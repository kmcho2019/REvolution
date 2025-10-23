module TopModule (
    input clk,
    input a,
    output reg q
);

    reg seen_a;

    initial begin
        q = 1'b0;
        seen_a = 1'b0;
    end

    always @(posedge clk) begin
        if (!seen_a) begin
            q <= 1'b1;
            if (a) begin
                seen_a <= 1'b1;
            end
        end else begin
            q <= 1'b0;
        end
    end

endmodule