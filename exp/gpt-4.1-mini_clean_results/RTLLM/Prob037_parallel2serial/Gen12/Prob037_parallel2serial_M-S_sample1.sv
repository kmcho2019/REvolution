module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;

    // dout selects bit from d starting from MSB (3) down to LSB (0)
    assign dout = d[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'b00;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt       <= 2'b00;
                valid_out <= 1'b1;
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule