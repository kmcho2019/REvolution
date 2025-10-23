module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] sync_chain;
reg [2:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sync_chain <= 2'b00;
        shift_reg <= 3'b000;
        data_out <= 1'b0;
    end
    else begin
        // Synchronize input (2FF synchronizer)
        sync_chain <= {sync_chain[0], data_in};
        
        // Update shift register every cycle
        shift_reg <= {shift_reg[1:0], sync_chain[1]};
        
        // Detect 0->1->0 pattern (3 cycles)
        data_out <= (shift_reg == 3'b010);
    end
end

endmodule