module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;

    assign dout = d[3 - cnt];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= (cnt == 2'b0);
            cnt       <= (cnt == 2'd3) ? 2'b0 : cnt + 1'b1;
        end
    end

endmodule