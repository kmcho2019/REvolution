module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg [3:0] data_reg; // 4-bit data storage

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            cnt <= 2'b0;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                // End of current conversion
                // Load new data and output MSB
                data_reg <= d;
                cnt <= 2'b0;
                dout <= d[3];
                valid_out <= 1'b1;
            end else begin
                // Continue current conversion
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;
                // Direct bit selection without shifting
                case (cnt)
                    2'b00: dout <= data_reg[2];
                    2'b01: dout <= data_reg[1];
                    2'b10: dout <= data_reg[0];
                    default: dout <= 1'b0;
                endcase
            end
        end
    end

endmodule