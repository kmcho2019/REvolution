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
            data      <= 4'd0;
            cnt       <= 2'd0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Last bit output this cycle
                data      <= d;          // Load new parallel data
                cnt       <= 2'd0;       // Reset counter
                valid_out <= 1'b1;       // Valid output at first bit
                dout      <= d[3];       // Output MSB of new data
            end else begin
                valid_out <= 1'b0;       // Valid only on first bit
                dout      <= data[3];    // Output MSB bit of current data
                data      <= {data[2:0], data[3]}; // Left rotate data
                cnt       <= cnt + 1'b1;
            end
        end
    end

endmodule