module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg [3:0] data;     // Data shift register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            cnt <= 2'b0;
            data <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Last bit - load new parallel data
                data <= d;
                cnt <= 2'b0;
                valid_out <= 1'b1;
            end else begin
                // Shift and output next bit
                data <= {data[2:0], 1'b0};  // Left shift
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
            dout <= data[3];  // Always output MSB
        end
    end

endmodule