module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;
    reg [1:0] bit_ptr;
    reg empty;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            bit_ptr <= 2'b0;
            empty <= 1'b1;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (empty) begin
                // Load new data when empty
                shift_reg <= d;
                bit_ptr <= 2'b0;
                empty <= 1'b0;
                valid_out <= 1'b1;
                dout <= d[3];  // Output MSB first
            end else begin
                // Shift operation
                if (bit_ptr == 2'b11) begin
                    // Last bit - prepare for next load
                    empty <= 1'b1;
                    valid_out <= 1'b0;
                end else begin
                    bit_ptr <= bit_ptr + 1;
                    valid_out <= 1'b1;
                end
                
                // Rotate and output next bit
                shift_reg <= {shift_reg[2:0], 1'b0};
                case (bit_ptr)
                    2'b00: dout <= shift_reg[2];
                    2'b01: dout <= shift_reg[1];
                    2'b10: dout <= shift_reg[0];
                    default: dout <= 1'b0;
                endcase
            end
        end
    end

endmodule