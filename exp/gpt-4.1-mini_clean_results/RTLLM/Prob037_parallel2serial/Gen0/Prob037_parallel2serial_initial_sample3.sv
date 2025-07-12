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
            cnt       <= 2'd3;  // Initialize to 3 so we load data at first cycle after reset
            data      <= 4'd0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new parallel data
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;
                dout      <= d[3];  // MSB output first
            end else begin
                // Shift data left by 1 bit: MSB shifted out on dout, shifted-in bit is MSB again (circular shift)
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1;
                valid_out <= 1'b0;
                dout      <= data[3];
            end
        end
    end

endmodule