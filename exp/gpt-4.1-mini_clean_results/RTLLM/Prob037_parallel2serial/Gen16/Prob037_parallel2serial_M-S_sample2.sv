module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;

    assign dout = d[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt       <= 2'd0;
                valid_out <= 1'b1; // valid on MSB output
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule