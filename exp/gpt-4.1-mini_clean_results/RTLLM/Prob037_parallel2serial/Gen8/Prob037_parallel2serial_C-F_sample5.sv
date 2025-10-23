module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Output the bit indexed by cnt, starting from MSB (bit 3) down to LSB (bit 0)
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt <= 2'b0;
                // Load new data on the next cycle (when cnt == 0)
                data <= d;
                valid_out <= 1'b1;  // Valid output asserted on first bit of new data
            end else begin
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;  // Valid only on first bit
            end
        end
    end

endmodule