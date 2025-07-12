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
            if (cnt == 2'd0) begin
                data      <= d;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end

            dout <= data[3 - cnt];  // Output bits from MSB to LSB

            cnt <= cnt + 1'b1;  // Count cycles 0 to 3 repeatedly
        end
    end

endmodule