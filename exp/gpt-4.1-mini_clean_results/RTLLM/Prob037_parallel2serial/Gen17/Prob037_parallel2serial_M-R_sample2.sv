module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       valid_out,
    output       dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    // Combinationally select output bit from registered data
    assign dout = data[3 - cnt];
    // valid_out asserted at counter 0, indicating fresh data loaded last cycle
    assign valid_out = (cnt == 2'd0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt  <= 2'd0;
            data <= 4'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt  <= 2'd0;
                data <= d;        // Load parallel data into register
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule