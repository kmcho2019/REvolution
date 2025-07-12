module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;  // 2-bit counter (0-3)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            valid_out <= (cnt == 2'b11);
            dout <= d[3-cnt];  // MSB first (d[3] when cnt=0)
            cnt <= cnt + 1;
        end
    end

endmodule