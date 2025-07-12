module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] bit_cnt;  // Counts 0-7
    reg [7:0] shift_reg;
    
    // Valid when counter is at 7 and new valid data arrives
    assign dout_valid = (bit_cnt == 3'd7) && din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'b0;
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
        end
        else if (din_valid) begin
            // Shift in new bit
            shift_reg <= {shift_reg[6:0], din_serial};
            
            // Update counter
            if (bit_cnt == 3'd7) begin
                bit_cnt <= 3'b0;
                // Capture parallel output when 8th bit arrives
                dout_parallel <= {shift_reg[6:0], din_serial};
            end
            else begin
                bit_cnt <= bit_cnt + 1'b1;
            end
        end
    end

endmodule