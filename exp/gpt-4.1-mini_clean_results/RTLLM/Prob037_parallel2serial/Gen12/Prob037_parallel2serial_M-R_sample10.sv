module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output       dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // dout is the MSB of current data register
    assign dout = data[3];

    // valid_out is high when cnt == 3 (last bit cycle)
    assign valid_out = (cnt == 2'd3);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 4'b0;
            cnt  <= 2'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new data and reset counter
                data <= d;
                cnt  <= 2'b0;
            end else begin
                // Shift data left by 1 bit each cycle
                data <= {data[2:0], 1'b0};
                cnt  <= cnt + 1'b1;
            end
        end
    end

endmodule