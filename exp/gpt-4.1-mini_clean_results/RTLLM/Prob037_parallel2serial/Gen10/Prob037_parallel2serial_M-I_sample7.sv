module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    // MSB of data is output serial bit
    assign dout = data[3];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Last bit sent; load new parallel data
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;  // Valid asserted on first bit output cycle
            end else begin
                // Shift data left by 1, discard MSB
                data      <= {data[2:0], 1'b0};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule