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
            cnt       <= 2'd0;
            data      <= 4'd0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                data      <= d;           // Load new parallel data
                dout      <= d[3];        // Output MSB first
                valid_out <= 1'b1;        // Valid output available
                cnt       <= cnt + 1;
            end else if (cnt < 2'd3) begin
                dout      <= data[3 - cnt]; // Output next bit from MSB to LSB
                valid_out <= 1'b1;          // Valid output available
                cnt       <= cnt + 1;
            end else begin
                dout      <= data[0];       // Output LSB bit (last bit)
                valid_out <= 1'b1;          // Valid output available
                cnt       <= 2'd0;          // Reset counter for next load
            end
        end
    end

endmodule