module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'd3;    // Start from MSB bit index 3
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Last bit output in previous cycle; load new data and restart
                data      <= d;
                cnt       <= 2'd3;
                valid_out <= 1'b1;
                dout      <= d[3];
            end else begin
                cnt       <= cnt - 1'b1;
                valid_out <= 1'b0;
                // Output next bit in sequence
                dout      <= data[cnt - 1'b1];
            end
        end
    end

endmodule