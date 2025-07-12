module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit binary counter (0-3)
    reg [3:0] data;     // Combined data storage and shift register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            // Update counter with automatic wrap-around
            cnt <= cnt + 1'b1;
            
            // Clock-gated shift register update
            if (cnt == 2'b11) begin  // Terminal count
                data <= d;          // Load new data
            end else begin
                data <= {data[2:0], 1'b0};  // Shift left
            end
            
            // Always output MSB
            dout <= data[3];
            
            // Valid when first bit is being output
            valid_out <= (cnt == 2'b11);
        end
    end

endmodule