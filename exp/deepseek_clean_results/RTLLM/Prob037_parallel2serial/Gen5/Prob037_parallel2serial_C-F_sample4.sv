module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data_reg;  // Register to hold parallel data
    reg [1:0] cnt;       // 2-bit counter (0-3)
    reg load_new;        // Signal to load new data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            data_reg <= 4'b0;
            cnt <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            load_new <= 1'b1;
        end else begin
            // Update load_new signal
            load_new <= (cnt == 2'b11);

            if (load_new) begin
                // Load new data and output MSB
                data_reg <= d;
                cnt <= 2'b0;
                valid_out <= 1'b1;
                dout <= d[3];
            end else begin
                // Output next bit
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;
                dout <= data_reg[2-cnt];  // Direct bit selection
            end
        end
    end

endmodule