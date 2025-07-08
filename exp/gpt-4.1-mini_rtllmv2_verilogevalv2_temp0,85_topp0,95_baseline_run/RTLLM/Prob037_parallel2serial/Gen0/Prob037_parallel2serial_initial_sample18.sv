module parallel2serial (
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
            cnt       <= 2'd0;
            data      <= 4'd0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            dout <= data[3];  // Output MSB
            
            if (cnt == 2'd3) begin
                // Last bit: load new data, reset counter, valid_out = 1
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;
            end else begin
                // Shift data circularly left by 1 bit: MSB to LSB
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule