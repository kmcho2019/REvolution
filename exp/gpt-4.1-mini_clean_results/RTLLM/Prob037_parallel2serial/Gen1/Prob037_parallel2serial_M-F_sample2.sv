module parallel2serial (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [3:0] d,
    output reg        valid_out,
    output reg        dout
);

    reg [3:0] data;
    reg [1:0] cnt;  // 2-bit counter to count from 0 to 3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            data      <= 4'd0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Load new data at the start of serialization
                data      <= d;
                dout      <= d[3];      // Output MSB immediately
                valid_out <= 1'b1;      // valid_out asserted for MSB output
                cnt       <= 2'd1;      // Move to next bit index
            end else begin
                // Shift data left by 1 bit (MSB shifted out, next bit moves into MSB)
                data      <= {data[2:0], 1'b0};
                dout      <= data[2];   // After shift, output next MSB bit
                valid_out <= 1'b0;      // valid_out low for bits after MSB
                if (cnt == 2'd3) begin
                    // Last bit output, reset counter to load new data next cycle
                    cnt <= 2'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule