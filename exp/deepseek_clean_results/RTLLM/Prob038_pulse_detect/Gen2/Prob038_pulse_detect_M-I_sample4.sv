module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] sync_chain;
reg [1:0] shift_reg;
reg last_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sync_chain <= 2'b00;
        shift_reg <= 2'b00;
        last_data <= 1'b0;
        data_out <= 1'b0;
    end
    else begin
        // Synchronize input (2FF synchronizer)
        sync_chain <= {sync_chain[0], data_in};
        
        // Only update shift register when input changes
        if (sync_chain[1] != last_data) begin
            shift_reg <= {shift_reg[0], sync_chain[1]};
            last_data <= sync_chain[1];
        end
        
        // Detect 0->1->0 pattern
        data_out <= (shift_reg == 2'b10) && !sync_chain[1];
    end
end

endmodule