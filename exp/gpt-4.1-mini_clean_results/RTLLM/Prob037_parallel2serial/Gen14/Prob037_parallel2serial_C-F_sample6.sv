module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [1:0] cnt;

    // Output bit directly indexed from d using cnt; MSB at cnt=3 down to LSB at cnt=0
    assign dout = d[cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd3;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                valid_out <= 1'b1;   // Valid asserted on MSB bit output cycle
                cnt       <= cnt - 1'b1;
            end else if (cnt == 2'd0) begin
                valid_out <= 1'b0;
                cnt       <= 2'd3;   // Reset counter after outputting LSB
            end else begin
                valid_out <= 1'b0;
                cnt       <= cnt - 1'b1;
            end
        end
    end

endmodule