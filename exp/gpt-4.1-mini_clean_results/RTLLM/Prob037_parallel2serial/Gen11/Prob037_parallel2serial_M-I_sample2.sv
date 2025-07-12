module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;

    // Output bit indexed directly from input d from MSB to LSB according to cnt
    assign dout = d[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'b00;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt       <= 2'b00;
            end else begin
                cnt       <= cnt + 1'b1;
            end
            // valid_out is asserted when cnt == 0 (first bit output)
            valid_out <= (cnt == 2'd0) ? 1'b1 : 1'b0;
        end
    end

endmodule