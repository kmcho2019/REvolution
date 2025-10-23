module parallel2serial (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [3:0] d,
    output reg        valid_out,
    output reg        dout
);

    reg [3:0] data;
    reg [1:0] cnt;  // 2-bit counter for counts 0 to 3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            data      <= 4'd0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new data, output MSB, set valid_out
                data      <= d;
                dout      <= d[3];
                valid_out <= 1'b1;
                cnt       <= 2'd0;
            end else begin
                // Shift data left by 1 with MSB wrapped to LSB
                data      <= {data[2:0], data[3]};
                dout      <= data[3];  // MSB of current data
                valid_out <= 1'b0;
                cnt       <= cnt + 1'b1;
            end
        end
    end

endmodule