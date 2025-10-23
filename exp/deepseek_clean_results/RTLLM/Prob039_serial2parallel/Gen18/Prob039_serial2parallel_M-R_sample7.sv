module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output wire [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    reg [7:0] out_reg;
    reg valid_reg;

    // Continuous assignments
    assign dout_parallel = out_reg;
    assign dout_valid = valid_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'b0;
            shift_reg <= 8'b0;
            out_reg <= 8'b0;
            valid_reg <= 1'b0;
        end
        else begin
            valid_reg <= 1'b0;  // Default to 0 unless we complete a byte
            
            if (din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial};
                
                if (bit_cnt == 3'd7) begin
                    out_reg <= {shift_reg[6:0], din_serial};
                    valid_reg <= 1'b1;
                    bit_cnt <= 3'b0;
                end
                else begin
                    bit_cnt <= bit_cnt + 1'b1;
                end
            end
        end
    end

endmodule