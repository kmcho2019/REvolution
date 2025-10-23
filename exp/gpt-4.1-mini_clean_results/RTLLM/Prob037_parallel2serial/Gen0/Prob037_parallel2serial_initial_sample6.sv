module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg       valid_out,
    output reg       dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1;
            end else begin
                cnt       <= cnt + 1;
                valid_out <= 1'b0;
                // Shift left by one with MSB wrapping to LSB
                data <= {data[2:0], data[3]};
            end
            dout <= data[3];
        end
    end

endmodule