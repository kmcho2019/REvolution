module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 4'd0;
            shift_reg <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default assignment
            
            if (din_valid) begin
                if (bit_cnt == 4'd7) begin
                    // On the 8th valid input, capture the parallel output
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    bit_cnt <= 4'd0;
                end
                else begin
                    // Shift in new bit and increment counter
                    shift_reg <= {shift_reg[6:0], din_serial};
                    bit_cnt <= bit_cnt + 4'd1;
                end
            end
        end
    end

endmodule