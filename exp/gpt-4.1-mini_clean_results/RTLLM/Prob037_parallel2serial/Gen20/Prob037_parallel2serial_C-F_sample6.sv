module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // dout outputs bits from data from MSB to LSB indexed by (3 - cnt)
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;        // Load new parallel data at end of current serial output
                cnt       <= 2'd0;     // Reset counter for next 4-bit output cycle
                valid_out <= 1'b1;     // Assert valid_out when outputting MSB (first bit)
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;     // De-assert valid_out on other bits
            end
        end
    end

endmodule