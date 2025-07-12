module TopModule(
    input clk,
    input a,
    output reg q
);
    reg prev_a;

    initial begin
        q = 1'b0;
        prev_a = 1'b0;
    end

    always @(posedge clk) begin
        prev_a <= a;
        if (a == 1'b0) begin
            q <= 1'b1;
        end else if (a == 1'b1 && prev_a == 1'b1) begin
            q <= 1'b0;
        end
        // else q holds its value
    end
endmodule