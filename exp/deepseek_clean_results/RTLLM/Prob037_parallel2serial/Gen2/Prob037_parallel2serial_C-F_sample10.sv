module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data;     // Data register (no shifting needed)
    reg [3:0] cnt;      // One-hot counter (bit 0-3)
    reg [1:0] bit_sel;  // Current bit position (0-3)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            cnt <= 4'b0001;  // One-hot: starts at bit 0
            data <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            bit_sel <= 2'b00;
        end else begin
            if (cnt[3]) begin
                // Last bit of current data - load new parallel data
                data <= d;
                cnt <= 4'b0001;  // Reset to bit 0
                valid_out <= 1'b1;
                bit_sel <= 2'b00;
                dout <= d[3];  // Output MSB
            end else begin
                // Shift out next bit
                cnt <= {cnt[2:0], 1'b0};  // One-hot shift
                valid_out <= 1'b0;
                bit_sel <= bit_sel + 1;
                // Select next bit without shifting data register
                case (bit_sel + 1)
                    2'b00: dout <= data[3];
                    2'b01: dout <= data[2];
                    2'b10: dout <= data[1];
                    2'b11: dout <= data[0];
                endcase
            end
        end
    end

endmodule