module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg [3:0] data;     // Data register (no shifting needed)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset clears all registers
            cnt <= 2'b0;
            data <= 4'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                // End of current conversion
                data <= d;          // Latch new data
                cnt <= 2'b0;        // Reset counter
                dout <= d[3];       // Output MSB immediately
            end else begin
                // Continue current conversion
                cnt <= cnt + 1'b1;
                // Output next bit without shifting (direct bit select)
                case (cnt)
                    2'b00: dout <= data[2];
                    2'b01: dout <= data[1];
                    2'b10: dout <= data[0];
                    default: dout <= 1'b0;
                endcase
            end
        end
    end

    // Combinatorial valid_out (only high when counter is 0)
    always @(*) begin
        valid_out = (cnt == 2'b0);
    end

endmodule