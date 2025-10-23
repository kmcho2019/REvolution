module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;

    // Select bit from input data indexed by counter, MSB first: dout = d[3 - cnt]
    assign dout = d[3 - cnt];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt       <= 2'b0;
                valid_out <= 1'b1;  // valid_out asserted on MSB output cycle (next cycle cnt=0)
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule