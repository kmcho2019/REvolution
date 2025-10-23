module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit binary counter (0-3)
    reg [3:0] data_reg;  // Parallel data storage

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin  // Last cycle
                data_reg <= d;        // Load new parallel data
                cnt <= 2'b00;         // Reset counter
                valid_out <= 1'b1;    // Valid when loading new data
                dout <= d[3];         // Output MSB first
            end else begin
                cnt <= cnt + 1;       // Increment counter
                valid_out <= 1'b0;    // Not valid during shifting
                dout <= data_reg[2'd3 - cnt];  // Output next bit
            end
        end
    end

endmodule