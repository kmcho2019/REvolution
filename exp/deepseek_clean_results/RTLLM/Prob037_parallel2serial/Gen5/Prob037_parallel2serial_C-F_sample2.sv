module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data;     // Data storage register
    reg [3:0] cnt;      // One-hot counter (4 states)
    wire last_bit = cnt[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            cnt <= 4'b0001;  // Initialize to first state
            data <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (last_bit) begin
                // Last bit of current conversion
                data <= d;          // Latch new parallel data
                cnt <= 4'b0001;     // Reset to first state
                dout <= d[3];       // Output MSB
                valid_out <= 1'b1;   // Assert valid
            end else begin
                // Shift out next bit
                cnt <= {cnt[2:0], 1'b0};  // Rotate left
                dout <= data[3-cnt];       // Select current bit
                valid_out <= 1'b0;
            end
        end
    end

endmodule