module TopModule(clk, j, k, Q);
    input clk, j, k;
    output reg Q;

    always @(posedge clk) begin
        if (j == 1'b0 && k == 1'b0) begin
            // do nothing, keep the old value
        end else if (j == 1'b0 && k == 1'b1) begin
            Q <= 1'b0;
        end else if (j == 1'b1 && k == 1'b0) begin
            Q <= 1'b1;
        end else if (j == 1'b1 && k == 1'b1) begin
            Q <= ~Q;
        end
    end
endmodule