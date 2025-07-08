module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [3:0] data;
    reg [1:0] cnt;  // 2-bit counter since count goes 0 to 3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'd3;  // Force load on first clock after reset
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new data and reset counter
                data      <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;      // Valid data starting with MSB output
                dout      <= d[3];      // Output MSB of new data
            end else begin
                // Shift data left by 1, MSB shifted to LSB
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1;
                valid_out <= 1'b0;
                dout      <= data[3];   // Output MSB after shift
            end
        end
    end

endmodule