module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data_reg;  // Parallel data storage
    reg [1:0] bit_ptr;   // Current bit position (0-3)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            data_reg <= 4'b0;
            bit_ptr <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (bit_ptr == 2'b0) begin
                // First cycle - load new data
                data_reg <= d;
                dout <= d[3];  // Output MSB
                valid_out <= 1'b1;
                bit_ptr <= bit_ptr + 1'b1;
            end else begin
                // Subsequent cycles
                valid_out <= 1'b0;
                case (bit_ptr)
                    2'b01: dout <= data_reg[2];
                    2'b10: dout <= data_reg[1];
                    2'b11: dout <= data_reg[0];
                endcase
                
                // Update pointer (wraps automatically)
                bit_ptr <= bit_ptr + 1'b1;
            end
        end
    end

endmodule