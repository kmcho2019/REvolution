module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [1:0] cnt;

    // Output bit selected by cnt from d (MSB first)
    assign dout = d[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3)
                cnt <= 2'd0;
            else
                cnt <= cnt + 1'b1;

            // valid_out is high only at the first output of a new 4-bit sequence
            valid_out <= (cnt == 2'd0);
        end
    end

endmodule