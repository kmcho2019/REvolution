module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg       valid_out,
    output reg       dout
);

    reg [3:0] data;    // Shift register holding data to serialize
    reg [1:0] cnt;     // 2-bit counter: 0 to 3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'd3;      // Initialize to 3 so that on first cycle data is loaded
            dout      <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new parallel data on last bit output
                data      <= d;
                dout      <= d[3];    // Output MSB first
                cnt       <= 2'd0;    // Reset counter to 0 for next bits
                valid_out <= 1'b1;
            end else begin
                // Shift data left by 1 with MSB wrapped into LSB
                // Extract MSB before shift
                wire msb = data[3];
                data <= {data[2:0], msb};
                // Output MSB of shifted data
                dout <= data[3];
                // Increment counter
                cnt <= cnt + 1;
                valid_out <= 1'b1;
            end
        end
    end

endmodule