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
            cnt       <= 2'd3;   // Initialize cnt to 3 to load new input on first cycle after reset
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new parallel data, output MSB, set valid_out
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;
                dout      <= d[3];
            end else begin
                // Shift data left by 1 bit (rotate MSB to LSB)
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
                dout      <= data[3];
            end
        end
    end

endmodule