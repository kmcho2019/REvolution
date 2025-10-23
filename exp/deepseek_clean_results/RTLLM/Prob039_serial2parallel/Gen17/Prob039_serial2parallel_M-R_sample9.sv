module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg output_ready;

    // Continuous assignment for valid signal
    assign dout_valid = output_ready;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
            bit_count <= 3'b0;
            output_ready <= 1'b0;
        end
        else begin
            output_ready <= 1'b0;  // Default to 0
            
            if (din_valid) begin
                // Shift in new bit
                shift_reg <= {shift_reg[6:0], din_serial};
                
                if (bit_count == 3'd7) begin
                    // When we have 8 bits, output them
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    output_ready <= 1'b1;
                    bit_count <= 3'b0;
                end
                else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end
    end

endmodule