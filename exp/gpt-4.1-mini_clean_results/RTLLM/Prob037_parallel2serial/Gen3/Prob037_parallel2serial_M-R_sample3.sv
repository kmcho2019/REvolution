module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg       valid_out,
    output reg       dout
);

    reg [3:0] data;
    reg [1:0] bit_idx;  // Bit index from 3 down to 0

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            bit_idx   <= 2'd3;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (bit_idx == 2'd3) begin
                // Load new parallel data and output MSB
                data      <= d;
                dout      <= d[3];
                valid_out <= 1'b1;
                bit_idx   <= bit_idx - 1;
            end else if (bit_idx != 2'd255) begin
                // Output next bits from MSB-1 down to LSB
                dout      <= data[bit_idx];
                valid_out <= 1'b1;
                if (bit_idx == 0) begin
                    // Finished last bit, next cycle load new data
                    bit_idx <= 2'd3;
                end else begin
                    bit_idx <= bit_idx - 1;
                end
            end
        end
    end

endmodule