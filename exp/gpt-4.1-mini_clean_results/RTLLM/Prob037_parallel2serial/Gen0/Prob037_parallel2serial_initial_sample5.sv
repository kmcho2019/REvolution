module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'd0;
            cnt       <= 2'd3;  // Set to 3 so that new data is loaded immediately on next cycle
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new data
                data      <= d;
                dout      <= d[3];
                valid_out <= 1'b1;
                cnt       <= 2'd0;
            end else begin
                // Shift left with MSB wrapping to LSB
                data      <= {data[2:0], data[3]};
                dout      <= data[3];
                valid_out <= 1'b0;
                cnt       <= cnt + 1'b1;
            end
        end
    end

endmodule