module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] bit_counter;

    // Valid when counter is at 7 and input is valid
    assign dout_valid = (bit_counter == 3'd7) & din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            bit_counter <= 3'b0;
            dout_parallel <= 8'b0;
        end
        else begin
            if (din_valid) begin
                // Shift in new bit at current position
                shift_reg[bit_counter] <= din_serial;

                // Update counter (automatically wraps from 7 to 0)
                bit_counter <= bit_counter + 1'b1;

                // Capture parallel output when counter is at 7
                if (bit_counter == 3'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial};
                end
            end
        end
    end

endmodule