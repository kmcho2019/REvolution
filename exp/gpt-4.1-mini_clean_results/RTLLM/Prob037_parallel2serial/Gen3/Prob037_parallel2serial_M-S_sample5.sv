module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            valid_out <= 1'b1;
            dout      <= d[3 - cnt];  // Output bits from MSB to LSB
            if (cnt == 2'd3)
                cnt <= 2'b0;
            else
                cnt <= cnt + 1'b1;
        end
    end

endmodule