module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data;     // Shift register to hold parallel data
    reg [1:0] cnt;      // 2-bit counter (0-3)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            data <= 4'b0;
            cnt <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end
        else begin
            if (cnt == 2'b11) begin
                // Last bit of current data - load new parallel data
                data <= d;
                cnt <= 2'b0;
                valid_out <= 1'b1;
            end
            else begin
                // Not last bit - continue shifting
                data <= {data[2:0], data[3]};  // Rotate left
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
            
            // Output MSB of shift register
            dout <= data[3];
        end
    end

endmodule