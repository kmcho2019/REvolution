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
            dout      <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            dout      <= d[3 - cnt];        // Output bits MSB to LSB
            valid_out <= (cnt == 2'd0);    // Valid only when outputting MSB bit

            if (cnt == 2'd3)
                cnt <= 2'b0;                // Wrap counter after last bit
            else
                cnt <= cnt + 1'b1;          // Increment counter
        end
    end

endmodule