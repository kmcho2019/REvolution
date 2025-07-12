module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // dout is current bit selected by cnt, from MSB to LSB: bit 3 down to bit 0
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b11;  // Initialize to last bit so next cycle loads
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Reload data and output MSB
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;
            end else begin
                // Output next bit and increment counter
                cnt       <= cnt + 1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule