module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Continuous assignment for valid signal
    assign dout_valid = (bit_count == 3'd0) && din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            bit_count <= 3'd0;
            dout_parallel <= 8'b0;
        end
        else if (din_valid) begin
            // Shift in new bit (MSB first)
            shift_reg <= {shift_reg[6:0], din_serial};
            
            // Automatic counter wrap at 7
            bit_count <= bit_count + 1'b1;

            // Capture complete byte when counter wraps
            if (bit_count == 3'd7) begin
                dout_parallel <= {shift_reg[6:0], din_serial};
            end
        end
    end

endmodule