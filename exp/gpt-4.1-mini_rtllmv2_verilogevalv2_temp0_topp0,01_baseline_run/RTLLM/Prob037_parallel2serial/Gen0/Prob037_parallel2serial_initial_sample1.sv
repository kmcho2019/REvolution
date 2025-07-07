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
            cnt       <= 2'b0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Last bit output, load new data and reset counter
                data      <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1;
                dout      <= d[3]; // MSB of new data
            end else begin
                // Shift data left by 1 bit, MSB shifted out to dout
                data      <= {data[2:0], 1'b0};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
                dout      <= data[3];
            end
        end
    end

endmodule