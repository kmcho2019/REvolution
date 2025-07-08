module parallel2serial(
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 4'b0;
            cnt <= 2'd3;  // So that on first cycle after reset we load new data and output MSB
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new data, output MSB, valid_out = 1
                data <= d;
                cnt <= 2'd0;
                valid_out <= 1'b1;
                dout <= d[3];
            end else begin
                // Shift data left with wrap-around (rotate)
                data <= {data[2:0], data[3]};
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;
                dout <= data[3];
            end
        end
    end

endmodule