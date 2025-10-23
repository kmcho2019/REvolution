module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg [3:0] data;     // Shift register

    assign dout = data[3];
    assign valid_out = (cnt == 2'b00);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data <= 4'b0;
        end else begin
            if (cnt == 2'b11) begin
                data <= d;
            end else begin
                data <= {data[2:0], 1'b0};
            end
            cnt <= cnt + 1'b1;
        end
    end

endmodule