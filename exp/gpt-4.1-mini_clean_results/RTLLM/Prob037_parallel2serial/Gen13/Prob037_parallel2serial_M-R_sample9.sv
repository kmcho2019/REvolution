module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // dout is data bit indexed by cnt: MSB first (bit 3 down to bit 0)
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Load new data and assert valid_out
                data      <= d;
                valid_out <= 1'b1;
                cnt       <= cnt + 1'b1;
            end else if (cnt <= 2'd3) begin
                // Output next bits, valid_out low
                valid_out <= 1'b0;
                cnt       <= cnt + 1'b1;
            end else begin
                // After last bit, wrap counter to 0 to load new data next cycle
                cnt       <= 2'b0;
                valid_out <= 1'b0;
            end
        end
    end

endmodule