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
    wire counter_full;

    // Early detection of full condition
    assign counter_full = (bit_counter == 3'd7);

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
                // Reverse shift: new bits enter at MSB, others shift right
                shift_reg <= {din_serial, shift_reg[7:1]};

                // Update counter
                if (counter_full) begin
                    bit_counter <= 3'b0;
                end
                else begin
                    bit_counter <= bit_counter + 1;
                end

                // Output generation happens one cycle after counter_full
                if (bit_counter == 3'd6 && din_valid) begin
                    dout_parallel <= {din_serial, shift_reg[7:1]};
                    dout_valid <= 1'b1;
                end
            end
        end
    end

endmodule