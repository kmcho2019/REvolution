module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default value
            
            if (din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial};
                
                // Check if we've received 8 bits (shift_reg will be full next cycle)
                if (&shift_reg[6:0]) begin  // All bits 1-7 are 1 (8th bit coming)
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                end
            end
        end
    end

endmodule