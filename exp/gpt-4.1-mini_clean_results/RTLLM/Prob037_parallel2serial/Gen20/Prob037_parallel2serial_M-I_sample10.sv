module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            valid_out <= 1'b0;
            data      <= 4'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load parallel input at end of serialization cycle
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;  // MSB will be output next cycle
            end else begin
                data      <= {data[2:0], 1'b0};  // shift left by one
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule