module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit binary counter (0-3)
    reg [3:0] data;     // Data storage register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin  // Last cycle
                data <= d;          // Load new data
                cnt <= 2'b00;       // Reset counter
                dout <= d[3];       // Output MSB
                valid_out <= 1'b1;   // Valid on first bit
            end else begin
                cnt <= cnt + 1'b1;   // Increment counter
                dout <= data[2'b11 - cnt];  // Select current bit
                valid_out <= 1'b0;   // Only valid on first bit
            end
        end
    end

endmodule