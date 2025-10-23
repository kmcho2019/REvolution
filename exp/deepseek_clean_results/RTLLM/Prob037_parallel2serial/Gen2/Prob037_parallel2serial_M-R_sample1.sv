module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg [3:0] data;     // Data storage

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            cnt <= 2'b0;
            data <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Last bit - load new data
                data <= d;
                dout <= d[3];
                cnt <= 2'b0;
            end else begin
                // Output next bit
                case (cnt)
                    2'b00: dout <= data[2];
                    2'b01: dout <= data[1];
                    2'b10: dout <= data[0];
                    default: dout <= 1'b0;
                endcase
                cnt <= cnt + 1;
            end
            valid_out <= 1'b1;  // Always valid when not in reset
        end
    end

endmodule