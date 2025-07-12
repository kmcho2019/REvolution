module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output wire [7:0] dout_parallel,
    output wire dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] bit_counter;

    // Continuous output assignments
    assign dout_parallel = shift_reg;
    assign dout_valid = (bit_counter == 3'd7) & din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            bit_counter <= 3'b0;
        end
        else if (din_valid) begin
            // Shift register update
            shift_reg <= {shift_reg[6:0], din_serial};
            
            // Counter update (resets after 8 bits)
            if (bit_counter == 3'd7)
                bit_counter <= 3'b0;
            else
                bit_counter <= bit_counter + 1'b1;
        end
    end

endmodule