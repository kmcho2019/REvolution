module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] data_reg;     // Data register for parallel-to-serial conversion

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data at end of cycle
                cnt <= 2'b00;
                data_reg <= d;
                valid_out <= 1'b1;
                dout <= d[3];  // Output MSB immediately
            end else begin
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;
                // Shift left and output new MSB
                data_reg <= {data_reg[2:0], 1'b0};
                dout <= data_reg[2];  // Next bit is now in MSB position
            end
        end
    end

endmodule