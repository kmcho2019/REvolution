module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd3;
            data      <= 4'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new data and output MSB with valid_out=1
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;
            end else begin
                // Shift data left by 1 bit, increment counter, valid_out=0
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 2'd1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule