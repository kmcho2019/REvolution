module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] bit_ptr;  // Points to current output bit (0-3)
    reg [3:0] data_reg; // Holds parallel input data

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_ptr <= 2'b00;
            data_reg <= 4'b0000;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            // Update pointer and load new data when wrapping
            if (bit_ptr == 2'b11) begin
                bit_ptr <= 2'b00;
                data_reg <= d;
            end else begin
                bit_ptr <= bit_ptr + 1'b1;
            end

            // Output current bit based on pointer
            case (bit_ptr)
                2'b00: dout <= data_reg[3];
                2'b01: dout <= data_reg[2];
                2'b10: dout <= data_reg[1];
                2'b11: dout <= data_reg[0];
            endcase

            // Valid when pointer is 0 (first bit of new data)
            valid_out <= (bit_ptr == 2'b00);
        end
    end

endmodule