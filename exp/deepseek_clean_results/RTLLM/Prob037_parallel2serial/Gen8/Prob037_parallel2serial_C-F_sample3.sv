module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg [3:0] data_reg; // Shift register for data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            data_reg <= 4'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data and output MSB
                cnt <= 2'b0;
                data_reg <= d;
                valid_out <= 1'b1;
                dout <= d[3];
            end else begin
                // Shift and output next bit
                cnt <= cnt + 1;
                valid_out <= 1'b0;
                data_reg <= {data_reg[2:0], 1'b0}; // Rotate left
                dout <= data_reg[3]; // Always output MSB
            end
        end
    end

endmodule