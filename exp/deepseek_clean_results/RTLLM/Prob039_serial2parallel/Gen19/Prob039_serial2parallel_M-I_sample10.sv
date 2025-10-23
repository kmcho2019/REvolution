module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] shift_reg;
    reg collecting;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
            collecting <= 1'b1;
        end
        else begin
            dout_valid <= 1'b0;  // Default low
            
            if (collecting && din_valid) begin
                shift_reg <= {shift_reg[6:0], din_serial};
                
                // Check if we've collected all bits (MSB indicates completion)
                if (&shift_reg[6:0]) begin
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid <= 1'b1;
                    collecting <= 1'b0;
                end
            end
            else if (!collecting) begin
                // Ready for next collection
                collecting <= 1'b1;
                shift_reg <= 8'b0;
            end
        end
    end

endmodule