module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data;  // Register to hold parallel data
    reg [1:0] cnt;    // 2-bit counter (0-3)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            data <= 4'b0;
            cnt <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Last bit of current word - load new data
                data <= d;
                cnt <= 2'b0;
                valid_out <= 1'b1;
                dout <= d[3];  // Output MSB first
            end else begin
                // Shift out next bit
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;
                data <= {data[2:0], 1'b0};  // Left shift
                dout <= data[2];           // Next bit is now in position [2]
            end
        end
    end

endmodule