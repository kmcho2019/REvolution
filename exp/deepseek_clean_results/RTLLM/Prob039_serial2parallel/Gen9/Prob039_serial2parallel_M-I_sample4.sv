module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] bit_counter;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_counter <= 3'b0;
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Default outputs
            dout_valid <= 1'b0;

            if (din_valid) begin
                // Left shift with new bit in LSB
                shift_reg <= {shift_reg[6:0], din_serial};

                // Update counter
                if (bit_counter == 3'd7) begin
                    bit_counter <= 3'b0;
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                end
                else begin
                    bit_counter <= bit_counter + 1;
                end
            end
        end
    end

endmodule