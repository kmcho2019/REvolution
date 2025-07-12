module TopModule(clk, ar, d, q);
    input clk, ar, d;
    output q;
    reg q;

    always @(posedge clk or posedge ar) begin
        if (ar) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end

endmodule