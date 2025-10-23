module TopModule(clk, a, q);
    input clk, a;
    output [2:0] q;
    reg [2:0] q;

    initial q = 3'bxxx;

    always @(posedge clk) begin
        if (~a) begin
            if (q == 3'b110) begin
                q <= 3'b000;
            end else begin
                q <= q + 1;
            end
        end else begin
            if (q == 3'bxxx) begin
                q <= 3'b100;
            end
        end
    end

endmodule