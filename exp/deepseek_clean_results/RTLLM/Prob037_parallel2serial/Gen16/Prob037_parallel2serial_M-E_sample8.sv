module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] ptr;  // Circular pointer (0-3)
    reg [3:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ptr <= 2'b00;
            data_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            // Pointer logic
            if (ptr == 2'b11) begin
                ptr <= 2'b00;
                data_reg <= d;  // Load new data when wrapping
            end else begin
                ptr <= ptr + 1'b1;
            end

            // Output selection
            case (ptr)
                2'b00: dout <= data_reg[3];
                2'b01: dout <= data_reg[2];
                2'b10: dout <= data_reg[1];
                2'b11: dout <= data_reg[0];
            endcase

            // Valid signal (asserted when outputting MSB)
            valid_out <= (ptr == 2'b00);
        end
    end

endmodule